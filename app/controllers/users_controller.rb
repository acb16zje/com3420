# frozen_string_literal: true

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
  def edit; end

  # POST /users
  def create
    @user = User.new(user_params)

    # Checks whether the user already exists
    if User.exists?(email: @user.email)
      redirect_to new_user_path, notice: 'Account already exists.'
    else
      # Gets the info for this email from MUSE
      @user.get_info_from_ldap
      if @user.uid == '' || @user.uid.nil?
        redirect_to new_user_path, notice: 'Not a valid email.'
      else
        @user.phone = '-' if @user.phone == '' || @user.phone.nil?

        if @user.save
          # email new user their details
          UserMailer.welcome(@user).deliver
          redirect_to @user, notice: 'User was successfully created.'
        else
          render :new
        end
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User was successfully deleted.'
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
