class AssetsController < ApplicationController
  def index
    render layout: 'application'
  end
  
  # GET /users/new
  def new
    @asset = Asset.new
  end
  
end