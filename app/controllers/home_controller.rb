class HomeController < ApplicationController
  def index
    @categories = Category.all
    render layout: 'application'
  end
end
