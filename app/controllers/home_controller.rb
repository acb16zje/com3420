class HomeController < ApplicationController
  def index
    @user_home_categories = UserHomeCategory.where(user: current_user)
    render layout: 'application'
  end
end
