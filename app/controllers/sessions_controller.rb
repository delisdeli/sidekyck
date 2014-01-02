class SessionsController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]
    if Provider.find_with_omniauth(auth)
        user = Provider.find_with_omniauth(auth).user
    else
      if current_user
        user = current_user
        if not current_user.providers.find_by_name(auth["provider"])
          user.add_provider(auth)
        end
      else
        user = User.create(name: auth["info"]["name"])
        user.add_provider(auth)
      end
    end
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

  def failure  
    redirect_to root_path, alert: "Authentication failed, please try again."  
  end

end
