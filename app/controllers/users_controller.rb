class UsersController < ApplicationController

  before_filter :signed_in_user,        only: [:edit]
  before_filter :correct_or_admin_user, only: [:edit] 
  before_filter :set_user

  def edit
  end

  def show
  end

  def destroy
    @user.destroy
    redirect_to root_url, notice: "Account has been deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end