class UserHomeCategoriesController < ApplicationController
  before_action :set_user_home_category, only: %i[show edit update destroy]
  load_and_authorize_resource

  # GET /user_home_categories
  def index
    @user_home_categories = UserHomeCategory.where(user_id: current_user.id)
  end

  # GET /user_home_categories/new
  def new
    # Get categories which are already favourites
    @bannedcatid = UserHomeCategory.select(:category_id).where(user_id: current_user.id
    # Get categories that can be set as a favourite
    @allowedcat = Category.where.not(id: @bannedcatid)
    # Create UserHomeCategory object for simpleform
    @user_home_category = UserHomeCategory.new
  end

  # POST /user_home_categories
  def create
    # Create the category from form parameters
    @user_home_category = UserHomeCategory.new(user_home_category_params)

    # Save and redirect back to homepage
    if @user_home_category.save
      redirect_to root_path, notice: 'Favourite category successfully added.'
    end
  end

  # DELETE /user_home_categories/1
  def destroy
    # Destroy category
    @user_home_category.destroy
    redirect_to user_home_categories_url, notice: 'Favourite category successfully removed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_home_category
    @user_home_category = UserHomeCategory.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_home_category_params
    params.require(:user_home_category).permit(:user_id, :category_id)
  end
end
