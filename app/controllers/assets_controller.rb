class AssetsController < ApplicationController
  def index
    @assets = Asset.all
    render layout: 'application'
  end

  # GET /assets/new
  def new
    @asset = Asset.new
  end

  # POST /assets
  def create
    @asset = Asset.new(user_params)

    if @asset.save
      redirect_to @asset, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
  params.require(:asset).permit(:forename,:surname,:password,:email,:phone,:department,:permission)
  end
end
