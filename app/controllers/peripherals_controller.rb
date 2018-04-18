class PeripheralsController < ApplicationController
  before_action :set_peripheral, only: [:show, :edit, :update, :destroy]

  # GET /peripherals
  # GET /peripherals.json
  def index
    @peripherals = Peripheral.all
  end

  # GET /peripherals/1
  # GET /peripherals/1.json
  def show
  end

  # GET /peripherals/new
  def new
    if (params[:item] != nil)
      @default = Item.find(params[:item])
    else
      @default = Item.first
    end
    @peripheral = Peripheral.new
  end


  # GET /peripherals/1/edit
  def edit
  end

  # POST /peripherals
  # POST /peripherals.json
  def create
    @p_array = Item.where(id: params[:peripheral][:peripheral_item_id])
    @parent = Item.find(params[:peripheral][:parent_item_id])

    peripherals_to_save = @p_array.map {|i| Peripheral.new(parent_item: @parent, peripheral_item: i)}
    if peripherals_to_save.each(&:save)
      redirect_to peripherals_path notice: 'Peripheral was successfully added.'
    else
      redirect_to peripherals_path notice: 'Peripheral was not added.'
    end
  end

  # PATCH/PUT /peripherals/1
  # PATCH/PUT /peripherals/1.json
  def update
    respond_to do |format|
      if @peripheral.update(peripheral_params)
        format.html { redirect_to @peripheral, notice: 'Peripheral was successfully updated.' }
        format.json { render :show, status: :ok, location: @peripheral }
      else
        format.html { render :edit }
        format.json { render json: @peripheral.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /peripherals/1
  # DELETE /peripherals/1.json
  def destroy
    @peripheral.destroy
    respond_to do |format|
      format.html { redirect_to peripherals_url, notice: 'Peripheral was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_peripheral
      @peripheral = Peripheral.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def peripheral_params
      params.require(:peripheral).permit(:parent_item_id, :peripheral_item_id)
    end
end
