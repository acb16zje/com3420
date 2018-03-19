class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  authorize_resource
  attr_accessor :item_id_list

  # GET /items
  def index
    @items = Item.all
    gon.category = params[:category_name]
  end

  #Get /items/manager
  def manager
    @items = Item.where("user_id = ?", params[:user_id])
    @manager = User.find_by_id(params[:user_id])
  end

  # GET /items/1
  def show
    @bookings = Booking.joins(:item).where("bookings.item_id = items.id", @item.id)
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id

    category = Category.find_by_id(@item.category_id)
    id_str = (Item.where(category_id: @item.category_id).count() + 1).to_s
    (0...(5 - id_str.length)).each do |i|
      id_str = '0' + id_str
    end
    @item.serial_id = category.tag + id_str

    if @item.save
      redirect_to @item, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    redirect_to items_path, notice: 'Item was successfully deleted.'
  end

  # GET
  def change_manager_multiple
    @item = Item.new
    @users = User.where("permission_id > ?", 1)
  end

  # POST
  def update_manager_multiple
    item_ids = params[:item][:item_id_list].split(' ')
    @items = Item.where(id: item_ids)

    @items.each do |item|
      item.user_id = params[:item][:user_id]
      item.save()
    end

    redirect_to manager_items_path(user_id: current_user.id), notice: 'Item was successfully moved.'
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
