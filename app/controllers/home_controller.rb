class HomeController < ApplicationController
  def index
    @categories = Category.all
    @item = Item.new
    render layout: 'application'
  end
end
