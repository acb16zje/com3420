class BookingItemsController < ApplicationController
  before_action :set_booking_item, only: [:show, :edit, :update, :destroy]

  # GET /booking_items
  # GET /booking_items.json
  def index
    @booking_items = BookingItem.all
  end

  # GET /booking_items/1
  # GET /booking_items/1.json
  def show
  end

  # GET /booking_items/new
  def new
    @booking_item = BookingItem.new
  end

  # GET /booking_items/1/edit
  def edit
  end

  # POST /booking_items
  # POST /booking_items.json
  def create
    @booking_item = BookingItem.new(booking_item_params)

    respond_to do |format|
      if @booking_item.save
        format.html { redirect_to @booking_item, notice: 'Booking item was successfully created.' }
        format.json { render :show, status: :created, location: @booking_item }
      else
        format.html { render :new }
        format.json { render json: @booking_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /booking_items/1
  # PATCH/PUT /booking_items/1.json
  def update
    respond_to do |format|
      if @booking_item.update(booking_item_params)
        format.html { redirect_to @booking_item, notice: 'Booking item was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking_item }
      else
        format.html { render :edit }
        format.json { render json: @booking_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /booking_items/1
  # DELETE /booking_items/1.json
  def destroy
    @booking_item.destroy
    respond_to do |format|
      format.html { redirect_to booking_items_url, notice: 'Booking item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking_item
      @booking_item = BookingItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_item_params
      params.require(:booking_item).permit(:item_id, :booking_id)
    end
end
