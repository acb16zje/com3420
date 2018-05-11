require 'irb'

class HomeController < ApplicationController
  def index
    # Load the user's favourites
    @user_home_categories = UserHomeCategory.where(user: current_user)

    # Load data for search bar autocomplete
    @autocomplete = [
      Item.pluck(:name, :serial),
      Item.pluck(:manufacturer).uniq,
      Category.pluck(:name)].reduce([], :concat).to_s.tr('[]"', '')

    render layout: 'application'
  end
end
