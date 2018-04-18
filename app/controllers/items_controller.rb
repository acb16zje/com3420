require 'irb'

class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /items
  def index
    @items = Item.all
    gon.category = params[:category_name]
  end

  # GET /items/manager
  def manager
    #@items = Item.where('user_id = ?', params[:user_id])
    @manager = User.find_by_id(params[:user_id])
    if (params[:tab] == "OnLoan")
      @items = Item.joins(:bookings).where(:bookings => {:status => "3"}).where(:user_id => current_user.id)
    elsif (params[:tab] == "Issue")
      @items = Item.joins(:bookings).where(:user_id => current_user.id, :condition => ['Damaged', 'Missing']).or(Item.joins(:bookings).where("bookings.status = ?", 7))
    else
      @items = Item.where('user_id = ?', params[:user_id])
    end
  end

  # GET /items/1
  def show
    @bookings = Booking.joins(:user).where('bookings.item_id = ?', @item.id)
    peripherals_for_item = Peripheral.where(parent_item: @item)
    @peripherals = @item.getItemPeripherals

    if !@item.parent_asset_serial.blank?
      @parent = Item.where('serial = ?', @item.parent_asset_serial).first
    end
  end

  # GET /items/1/add_peripheral_option
  def add_peripheral_option
    @item = Item.find_by_id(params[:id])

    if !@item.category.has_peripheral
      redirect_to '/404'
    end
  end

  # GET /items/1/choose_peripheral
  def choose_peripheral
    @i = Item.find_by_id(params[:id])

    if !@i.category.has_peripheral
      redirect_to '/404'
    else
      @items = Item.all.where("(serial <> ?) AND (parent_asset_serial IS NULL OR parent_asset_serial = '')", @i.serial)
    end
  end

  # POST /items/1/add_peripheral
  def add_peripheral
    @item = Item.find_by_id(params[:id])

    @peripheral = Item.where("serial = ?", params[:peripheral_asset]).first
    @peripheral.parent_asset_serial = @item.serial
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
    if params[:is_peripheral]
      @parent = Item.where('serial = ?', params[:parent_asset_serial]).first
    end
  end

  # GET /items/1/edit
  def edit
    if params[:is_peripheral]
      @items = Item.all.where('id <> ?', params[:id])
    end
  end

  # POST /items
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    @item.location = params[:item][:location].titleize

    # Getting the category for the attached item
    if !@item.parent_asset_serial.blank?
      parent = Item.where('serial = ?', @item.parent_asset_serial).first
      parent.has_peripheral = true
      parent.save
      category = Category.where('name = ?', (parent.category.name + " - Peripherals")).first
      @item.category_id = category.id
    end

    if @item.save
      redirect_to @item, notice: 'Asset was successfully created.'
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      @item.location = params[:item][:location].titleize

      if params[:item][:parent_asset_serial].blank?
        @item.parent_asset_serial = nil
      end

      if params[:item][:condition] == 'Retired' && @item.retired_date.blank?
        @item.retired_date = Date.today
      elsif params[:item][:condition] != 'Retired' && !@item.retired_date.blank?
        @item.retired_date = nil
      end

      if @item.save
        redirect_to @item, notice: 'Asset was successfully updated.'
      end
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

  # GET /items/import
  def import
  end

  # POST /items/import_file
  def import_file
    excel_import = Importers::ItemImporter.new(params[:import_file][:file].tempfile.path)
    res = excel_import.import(current_user)

    # Error message 0
    if res[0] == 0
      redirect_to import_items_path, notice: "The submitted file is not of file .xlsx format"
    # Error message 1
    elsif res[0] == 1
      redirect_to import_items_path, notice: "Headers of excel sheet do not match appropriate format."
    elsif res[0] == 2
      incorrect_rows = res[1]
      if incorrect_rows.blank?
        redirect_to import_items_path, notice: "Import was successful and no problems occured"
      else
        redirect_to controller: 'items', action: 'import', incorrect_rows: incorrect_rows, notice: "Import was partially successful, view rows that had problems below"
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
