class HomeController < ApplicationController
  def index
    @user_home_categories = UserHomeCategory.where(user: current_user)
    @autocomplete = [
      Item.pluck(:name, :serial),
      Item.pluck(:manufacturer).uniq,
      Category.pluck(:name)].reduce([], :concat).to_s.tr('[]"', '')

    render layout: 'application'
  end
end
