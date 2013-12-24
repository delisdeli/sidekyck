class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  def self.request(user, friend)
    unless user == friend or Friendship.exists?(user_id: user, friend_id: friend)
      transaction do
        Friendship.create(:user => user, :friend => friend, :status => 'pending')
        Friendship.create(:user => friend, :friend => user, :status => 'requested')
      end
    else
      return "failed"
    end
  end

  def self.accept(user, friend)
    unless user == friend or Friendship.exists?(user_id: user, friend_id: friend, status: 'active')
      transaction do
        accept_one_side(user, friend)
        accept_one_side(friend, user)
      end
    else
      return "failed"
    end
  end

  def self.accept_one_side(user, friend)
    request = find_by_user_id_and_friend_id(user, friend)
    request.status = 'accepted'
    request.save!
  end

  def proper_destroy_message
    if self.status == "accepted"
      return "You have ended a friendship."
    elsif self.status == "requested"
      return "You have declined a friendship."
    elsif self.status == "pending"
      return "Friend request canceled."
    end
  end

end
