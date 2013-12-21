class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_or_admin_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:index]

  # GET /users
  def index
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

    if @user.save
      sign_in @user
      redirect_to @user, notice: "Welcome, #{@user.name}"
    else
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.authenticate(params[:user][:password_authenticate]) and @user.update(user_params)
      redirect_to @user, notice: 'Information was successfully updated.'
    else
      flash[:notice] = 'Wrong password.' unless @user.authenticate(params[:user][:password_authenticate])
      render action: 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to root_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
