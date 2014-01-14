class FriendshipController < ApplicationController
  before_filter :signed_in?

  def create
    friend = User.find_by_id(params[:friend_id])
    if params[:sent_request]
      unless Friendship.request(current_user, friend) == "failed"
        flash[:green] = "Friendship request sent."
        friend.send_friend_request_notification(current_user)
      else
        flash[:blue] = "Friend request pending."
      end
    elsif params[:accept_request]
      unless Friendship.accept(current_user, friend) == "failed"
        flash[:green] = "You are now friends!"
        friend.send_friend_acceptance_notification(current_user)
      else
        flash[:blue] = "You are already friends."
      end
    end

    redirect_to last_page
  end

  def destroy
    friend = User.find_by_id(params[:friend_id])
    @friendship = current_user.friendships.find_by_friend_id(friend)
    @complement_friendship = friend.friendships.find_by_friend_id(current_user)
    unless @friendship and @complement_friendship
      flash[:red] = "Cannot delete a friendship that doesn't exist."
      redirect_to last_page
    else
      friends_name = friend.name
      @friendship.destroy
      @complement_friendship.destroy
      flash[:blue] = "You have ended your friendship with #{friends_name}."
      redirect_to last_page
    end
  end
end
