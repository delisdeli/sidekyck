class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # include SessionsHelper

  before_action :read_notifications
  helper_method :current_user, :signed_in?, :correct_user?, :correct_or_admin_user?, :admin_user?, :current_user?, :last_page, :current_page

  def read_notifications
    if params[:read_notification] == "all"
      current_user.read_notifications
    elsif params[:read_notification]
      notification_id = params[:read_notification].to_i
      if current_user.notifications.find_by_id(notification_id)
        current_user.read_notification(notification_id)
      end
    end
  end

  def last_page
    if request.referer
      return request.referer
    end
    return root_url
  end

  def current_page
    if request.env['PATH_INFO']
      return request.env['PATH_INFO']
    end
    return root_url
  end

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

  def correct_user?
    @user = User.find(params[:id])
    !!current_user?(@user)
  end

  def admin_user?
    signed_in? and current_user.admin?
  end

  def correct_or_admin_user?
    correct_user? or (current_user and current_user.admin?)
  end  

  def current_user? user
    current_user == user
  end

# **** BEFORE FILTER METHODS ****

  def active_listing
    listing = Listing.find(params[:listing_id])
    unless listing.status == 'active'
      flash[:notice] = "Cannot create job for inactive listing"
      redirect_to root_url
    end
  end

  def service_owner
    service = Service.find(params[:id])
    service.customer_id == current_user.id or service.provider_id == current_user.id
  end
  
  def signed_in_user
    unless signed_in?
      # store_location
      flash[:red] = "Please sign in."
      redirect_to last_page
    end

  end

  def correct_user
    redirect_to(root_url) unless correct_user?
  end

  def admin_user
    unless current_user and current_user.admin?
      flash[:red] = "Must be admin user to access this feature."
      redirect_to(root_url)
    end
  end

  def correct_or_admin_user
    begin 
      @user = User.find(params[:id])
    rescue Exception => e
      redirect_to root_url, red: "You are not authorized to access this function."
    end
    unless current_user?(@user) or (current_user and current_user.admin?)
      flash[:red] = "You are not authorized to access this function."
      redirect_to(root_url)
    end
  end

  def store_referer
    session[:return_to] = request.referer
  end

end
