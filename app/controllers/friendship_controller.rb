class FriendshipController < ApplicationController
  before_filter :store_referer

  def create
    friend = User.find_by_id(params[:friend_id])
    if params[:sent_request]
      unless Friendship.request(current_user, friend) == "failed"
        flash[:notice] = "Friendship request sent."
        friend.send_friend_request_notification(current_user)
      else
        flash[:notice] = "Friend request pending."
      end
    elsif params[:accept_request]
      unless Friendship.accept(current_user, friend) == "failed"
        flash[:notice] = "You are now friends!"
        friend.send_friend_acceptance_notification(current_user)
      else
        flash[:notice] = "You are already friends."
      end
    end

    if session[:return_to]
      redirect_to session.delete(:return_to)
    else
      redirect_to root_url
    end
  end

  def destroy
    friend = User.find_by_id(params[:friend_id])
    @friendship = current_user.friendships.find_by_friend_id(friend)
    @complement_friendship = friend.friendships.find_by_friend_id(current_user)
    unless @friendship and @complement_friendship
      redirect_to root_url, notice: "Cannot delete a friendship that doesn't exist."
    else
      flash[:notice] = @friendship.proper_destroy_message
      @friendship.destroy
      @complement_friendship.destroy
      redirect_to current_user
    end
  end
end
