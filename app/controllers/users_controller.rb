require 'irb'

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  authorize_resource

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/manager
  def manager
    @users = User.all
  end

  # GET /users/1
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    item_list = Item.where(user: @user)
    @item_count = item_list.size
    @options = []

    if ((@user.permission_id > 1 && @item_count == 0) || (@user.permission_id == 1))
      @options << ['User', 1]
    end

    @options << ['Asset Manager', 2]
    @options << ['Administrator', 3]
  end

  # POST /users
  def create
    @user = User.new(user_params)

    # Checks whether the user already exists
    if User.exists?(email: @user.email)
      redirect_to new_user_path, alert: 'Account already exists.'
    else
      # Gets the info for this email from MUSE
      @user.get_info_from_ldap
      if @user.uid.blank?
        redirect_to new_user_path, alert: 'Not a valid email.'
      else
        @user.phone = '-' if @user.phone.blank?

        if @user.save
          # email new user their details
          UserMailer.welcome(@user).deliver
          redirect_to @user, notice: 'User was successfully created.'
        end
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    redirect_to @user, notice: 'User was successfully updated.' if @user.update(user_params)
  end

  # DELETE /users/1
  def destroy
    @items = Item.where(user_id: @user.id)

    if @items.blank?
      redirect_to users_path, notice: 'User was successfully deleted.' if @user.destroy
    else
      redirect_to change_manager_multiple_and_delete_items_path(id: @user.id)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).except(:bunny).permit!
  end
end
