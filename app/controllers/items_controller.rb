require 'irb'

class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]
  load_and_authorize_resource

  # GET /items
  def index
    @items = Item.all
    gon.category = params[:category_name]
  end

  # GET /items/manager
  def manager
    # @items = Item.where('user_id = ?', params[:user_id])
    if params[:user_id].to_i == current_user.id && current_user.permission_id == 1
      render 'errors/error_404'
    else
      @manager = User.find_by_id(params[:user_id])
      if params[:tab] == 'OnLoan'
        @bookings = Booking.joins(:item).where(status: %w[3 7], items: {user_id: current_user.id})
      elsif params[:tab] == 'Issue'
        @items = Item.where(user_id: current_user.id, condition: %w[Damaged Missing])
      else
        @items = Item.where(user_id: params[:user_id])
      end
    end
  end

  # GET /items/1
  def show
    @bookings = Booking.joins(:user).where(item_id: @item.id)

    @parents = @item.get_item_parents
    @peripherals = @item.get_item_peripherals
  end

  # GET /items/1/add_peripheral_option
  def add_peripheral_option
    @item = Item.find_by_id(params[:id])
  end

  # GET /items/1/choose_peripheral
  def choose_peripheral
    @item = Item.find_by_id(params[:id])

    @items = Item.where.not(serial: @item.serial)
    Item.all.each do |i|
      if !i.peripheral_items.where(parent_item_id: @item.id).blank? || !i.parent_items.where(peripheral_item_id: @item.id).blank?
        @items -= [i]
      end
    end
  end

  # POST /items/1/add_peripheral
  def add_peripheral
    @item = Item.find_by_id(params[:id])

    unless params[:peripheral_asset].blank?
      @peripheral = Item.find_by_serial(params[:peripheral_asset])
      pair = ItemPeripheral.create(parent_item_id: @item.id, peripheral_item_id: @peripheral.id)
      pair.save
      @item.save
    end

    redirect_to @item, notice: 'Peripheral was successfully added'
  end

  # GET /items/new
  def new
    @items = Item.all
    unless params[:item_id].blank?
      gon.parent_id = params[:item_id]
    end
  end

  # GET /items/1/edit
  def edit
    if params[:is_peripheral] == 'true'
      @items = Item.where.not(id: @item.id)
      Item.all.each do |i|
        # if !i.peripheral_items.where(parent_item_id: @item.id).blank? || !i.parent_items.where(peripheral_item_id: @item.id).blank?
        unless i.peripheral_items.where(parent_item_id: @item.id).blank?
          @items = @items - [i]
        end
      end
      @parents = @item.get_item_parents
  
      gon.parent_id = []
  
      @parents.each do |parent|
        gon.parent_id.append(parent.id)
      end
    end
  end

  # POST /items
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    @item.serial = params[:item][:serial].upcase.strip
    @item.location = params[:item][:location].titleize

    begin
      @item.save
      unless params[:item][:is_peripheral].blank?
        parents = params[:item][:add_parents]
        peripheral = @item.id
        parents.each do |parent|
          unless parent.blank?
            pair = ItemPeripheral.create(parent_item_id: parent.to_i, peripheral_item_id: peripheral)
            pair.save
          end
        end
      end
      redirect_to @item, notice: 'Asset was successfully created.'
    rescue
      redirect_to request.referrer, alert: 'The serial is already in use'
    end
  end

  # PATCH/PUT /items/1
  def update
    @item.update(item_params)
    @item.location = params[:item][:location].titleize.strip

    if params[:item][:condition] == 'Retired' && @item.retired_date.blank?
      @item.retired_date = Date.today
    elsif params[:item][:condition] != 'Retired' && !@item.retired_date.blank?
      @item.retired_date = nil
    end
    if @item.save
      unless params[:item][:is_peripheral].blank?
        parents = params[:item][:add_parents]
        peripheral = @item.id
        original_parents = @item.get_item_parents
        deleted_parents = original_parents
        parents.each do |parent|
          unless parent.blank?
            new_parent = Item.find(parent.to_i)
            unless deleted_parents.blank?
              deleted_parents -= [new_parent]
            end
            unless @item.get_item_parents.include? new_parent
              pair = ItemPeripheral.create(parent_item_id: parent.to_i, peripheral_item_id: peripheral)
              pair.save
            end
          end
        end

        deleted_parents.each do |deleted_parent|
          ItemPeripheral.where(parent_item_id: deleted_parent.id, peripheral_item_id: peripheral).first.destroy
        end
      end
      redirect_to @item, notice: 'Asset was successfully updated.'
    end
  rescue
    redirect_to request.referrer, alert: 'Serial already exist'
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    redirect_to items_path, notice: 'Asset was successfully deleted.'
  end

  # GET /items/change_manager_multiple
  def change_manager_multiple
    @item = Item.new
    @allowed_user = User.where.not(id: current_user.id, permission_id: 1)
  end

  # POST /items/change_manager_multiple
  def update_manager_multiple
    item_ids = params[:item][:item_id_list].split(' ')
    @items = Item.where(id: item_ids)

    @items.each do |item|
      item.user_id = params[:item][:user_id]
      item.save
    end

    redirect_to manager_items_path(user_id: current_user.id), notice: 'Ownership was successfully transfered.'
  end

  # GET /items/change_manager_multiple
  def change_manager_multiple_and_delete
    @item = Item.new
    @user = User.find_by_id(params[:user_id])
    @allowed_user = User.where.not(id: params[:user_id], permission_id: 1)
  end

  # POST /items/change_manager_multiple
  def update_manager_multiple_and_delete
    @items = Item.where(user_id: params[:item][:old_id])

    @items.each do |item|
      item.user_id = params[:item][:user_id]
      item.save
    end

    @user = User.find(params[:item][:old_id])

    if @user.destroy
      redirect_to users_path, notice: 'User was successfully deleted.'
    end
  end

  # GET /items/import
  def import; end

  # POST /items/import_file
  def import_file
    excel_import = Importers::ItemImporter.new(params[:import_file][:file].tempfile.path)
    res = excel_import.import(current_user)

    # Error message 0
    if res[0].zero?
      redirect_to import_items_path, alert: 'The submitted file is not of file .xlsx format'
    # Error message 1
    elsif res[0] == 1
      redirect_to import_items_path, alert: 'Headers of excel sheet do not match appropriate format'
    elsif res[0] == 2
      incorrect_rows = res[1]
      if incorrect_rows.blank?
        redirect_to import_items_path, notice: 'Import was successful and no problems occured'
      else
        redirect_to controller: 'items', action: 'import', incorrect_rows: incorrect_rows, alert: 'Import was partially successful, view rows that had problems below'
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def item_params
    params.require(:item).except(:bunny).permit!
  end
end
