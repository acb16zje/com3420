class HomeController < ApplicationController
  def index
    @user_home_categories = UserHomeCategory.where(user_id: current_user.id)
    @categories = Category.all
    render layout: 'application'
  end
end
