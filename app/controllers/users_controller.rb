class UsersController < ApplicationController

  before_filter :signed_in_user,        only: [:edit]
  before_filter :correct_or_admin_user, only: [:edit] 
  before_filter :set_user

  def edit
  end

  def show
    @to_show = params[:to_show]
  end

  def destroy
    @user.destroy
    flash[:green] = "Account has been deleted."
    redirect_to root_url
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end