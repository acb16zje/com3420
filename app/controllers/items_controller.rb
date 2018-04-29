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
        @items = Item.joins(:bookings).where(bookings: { status: '3' }).where(user_id: current_user.id)
      elsif params[:tab] == 'Issue'
        @items = Item.joins(:bookings).where(user_id: current_user.id, condition: %w[Damaged Missing]).or(Item.joins(:bookings).where('bookings.status = ?', 7))
      else
        @items = Item.where('user_id = ?', params[:user_id])
      end
    end
  end

  # GET /items/1
  def show
    @bookings = Booking.joins(:user).where('bookings.item_id = ?', @item.id)
    @peripherals = Item.where('items_id = ?', @item.id)

  end

  # GET /items/1/add_peripheral_option
  def add_peripheral_option
    @item = Item.find_by_id(params[:id])

    render 'errors/error_404' unless @item.category.has_peripheral
  end

  # GET /items/1/choose_peripheral
  def choose_peripheral
    @i = Item.find_by_id(params[:id])

    if !@i.category.has_peripheral
      render 'errors/error_404'
    else
      @items = Item.where("(serial <> ?) AND (items_id IS NULL) AND (user_id = ?)", @i.serial, current_user.id)
    end
  end

  # POST /items/1/add_peripheral
  def add_peripheral
    @item = Item.find_by_id(params[:id])

    @peripheral = Item.where('serial = ?', params[:peripheral_asset]).first
    @peripheral.items_id = @item.id
    @peripheral.save
    @item.has_peripheral = true
    @item.save
    redirect_to @item
  end

  # GET /items/new
  def new
    # Get items with categories allowing peripherals
    @items = []
    categories = Category.where('has_peripheral = TRUE')
    categories.each do |category|
      items = Item.where('category_id = ?', category.id)
      items.each do |i|
        @items.append(i)
      end
    end

    @item = Item.new
    if params[:is_peripheral] == "true"
      @parent = Item.where('id = ?', params[:items_id]).first
    end
  end

  # GET /items/1/edit
  def edit
    @items = Item.all.where('id <> ?', params[:id]) if params[:is_peripheral] == "true"
  end

  # POST /items
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    @item.serial = params[:item][:serial].upcase
    @item.location = params[:item][:location].titleize
    if !params[:item][:items_id].blank?
      @item.items_id = Item.where('serial = ?',params[:item][:items_id]).first.id
    end

    # Getting the category for the attached item
    unless @item.items_id.blank?
      parent = Item.where('id = ?', @item.items_id).first
      parent.has_peripheral = true
      parent.save
      category = Category.where('name = ?', (parent.category.name + ' - Peripherals')).first
      @item.category_id = category.id
    end

    begin @item.save
      redirect_to @item, notice: 'Asset was successfully created.'
    rescue
      redirect_to request.referrer, alert: 'The serial is already in use'
    end
  end

  # PATCH/PUT /items/1
  def update
    begin @item.update(item_params)
      @item.location = params[:item][:location].titleize.strip

      if params[:item][:items_id].blank?
        @item.items_id = nil
      end

      if params[:item][:condition] == 'Retired' && @item.retired_date.blank?
        @item.retired_date = Date.today
      elsif params[:item][:condition] != 'Retired' && !@item.retired_date.blank?
        @item.retired_date = nil
      end

      redirect_to @item, notice: 'Asset was successfully updated.' if @item.save
    rescue
      redirect_to request.referrer, alert: 'Serial already exist'
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    redirect_to items_path, notice: 'Asset was successfully deleted.'
  end

  # GET /items/change_manager_multiple
  def change_manager_multiple
    @item = Item.new
    @users = User.where('permission_id > ?', 1)
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
    @user = User.find_by_id(params[:id])
    @allowed_user = User.where('id <> ?', params[:id])
    @users = User.where('permission_id > ?', 1)
  end

  # POST /items/change_manager_multiple
  def update_manager_multiple_and_delete
    @items = Item.where(user_id: params[:item][:old_id])

    @items.each do |item|
      item.user_id = params[:item][:user_id]
      if !item.save
        redirect_to manager_items_path(user_id: params[:item][:old_id]), notice: 'Not All Items Could Be Moved'
      end
    end
    puts ("Here----------------------------------")
    puts (params[:item][:user_id])
    @user = User.find(params[:item][:old_id])
    if @user.destroy
      puts "DELETED"
      redirect_to users_path, notice: 'User was successfully deleted.'

    else
      puts "NOT DELETED"

      redirect_to users_path, notice: 'User was not deleted.'

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
