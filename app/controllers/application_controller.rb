class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # include SessionsHelper

  before_filter :check_for_notifications
  before_filter :check_for_friend_requests
  helper_method :current_user, :signed_in?, :correct_user?, :correct_or_admin_user?, :admin_user?, :current_user?

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end

  def check_for_notifications
    if params[:show_notifications] == "true"
      @show_notifications = true
      begin
        @user = User.find(params[:user_id])
      rescue Exception => e
        redirect_to root_url, notice: "That user doesn't exist" unless @user
        return
      end
      @unseen_notifications = @user.unseen_notifications
      p @unseen_notifications
      @user.read_notifications
    end
  end

  def check_for_friend_requests
    if params[:show_friend_requests] == "true"
      @show_friend_requests = true
      begin
        @user = User.find(params[:user_id])
      rescue Exception => e
        redirect_to root_url, notice: "That user doesn't exist" unless @user
        return
      end
    end
  end

  def correct_user?
    @user = User.find(params[:id])
    !!current_user?(@user)
  end

  def admin_user?
    signed_in? and current_user.admin?
  end

  def correct_or_admin_user?
    correct_user? or current_user.admin?
  end  

  def current_user? user
    current_user == user
  end

# **** BEFORE FILTER METHODS ****

  def active_listing
    listing = Listing.find(params[:listing_id])
    unless listing.status == 'active'
      redirect_to root_url, "Cannot create job for inactive listing"
    end
  end

  def service_owner
    service = Service.find(params[:id])
    service.customer_id == current_user.id or service.provider_id == current_user.id
  end
  
  def signed_in_user
    unless signed_in?
    # store_location
    redirect_to request.referer, notice: "Please sign in."
    end
  end

  def correct_user
    redirect_to(root_url) unless correct_user?
  end

  def admin_user
    unless current_user and current_user.admin?
    flash[:notice] = "Must be admin user to access this feature."
    redirect_to(root_url)
    end
  end

  def correct_or_admin_user
    begin 
      @user = User.find(params[:id])
    rescue Exception => e
      redirect_to root_url, notice: "You are not authorized to access this function."
    end
    unless current_user?(@user) or (current_user and current_user.admin?)
      flash[:notice] = "You are not authorized to access this function."
      redirect_to(root_url)
    end
  end

  def store_referer
    session[:return_to] = request.referer
  end

end
