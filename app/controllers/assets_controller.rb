class AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy]

  def index
    @assets = Asset.all
  end

  # GET /assets/new
  def new
    @asset = Asset.new
  end

  # GET /assets/1/edit
  def edit
  end

  # POST /assets
  def create
    @asset = Asset.new(user_params)

    if @asset.save
      redirect_to @asset, notice: 'Asset was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /assets/1
  def update
    if @asset.update(asset_params)
      redirect_to @asset, notice: 'Asset was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /assets/1
  def destroy
    @user.destroy
    redirect_to assets_url, notice: 'Asset was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @asset = Asset.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
    end
end
