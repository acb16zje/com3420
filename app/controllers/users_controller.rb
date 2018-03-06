class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /users
  def index
    @users = User.all
  end

  #Get /user/manager
  def manager
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    # Checks whether the user already exists
    if User.exists?(:email => @user.email)
      redirect_to new_user_path, notice: 'Account already exists.'
    else
      # Gets the info for this email from MUSE
      @user.get_info_from_ldap
      username = SheffieldLdapLookup::LdapFinder.new(@user.email).lookup[:uid]
      @user.username = username[0]

      if @user.phone == "" || @user.phone.nil?
        @user.phone = "-"
      end

      if @user.save
        redirect_to @user, notice: 'User was successfully created.'
      else
        render :new
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
		  params.require(:user).permit(:email, :permission_id)
    end
end
