class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :notifications,  dependent: :destroy
  has_many :friendships,  dependent: :delete_all
  has_many :accepted_friendships, -> { where status: 'accepted'}, :class_name => "Friendship"
  has_many :requested_friendships, -> { where status: 'requested'}, :class_name => "Friendship"
  has_many :pending_friendships, -> { where status: 'pending'}, :class_name => "Friendship"
  has_many :friends, :through => :accepted_friendships
  has_many :requested_friends, :through => :requested_friendships, :source => :friend
  has_many :pending_friends, :through => :pending_friendships, :source => :friend

  before_save :restrict_max_notifications
  before_destroy :destroy_complementary_friendships

  def is_user? current_user
    self == current_user
  end

  def unseen_notifications
    self.notifications.where(seen: false)
  end

  def unseen_notifications_count
    self.unseen_notifications.size
  end

  def has_unseen_notifications?
    self.unseen_notifications_count != 0
  end

  def restrict_max_notifications
    notifications_count = self.notifications.size
    if notifications_count > 50
      (notifications_count-50).times do 
        self.notifications.order(:created_at).first.delete
      end
    end
  end

  def read_notifications
    self.notifications.where(seen: false).each{ |notif| notif.update_attributes(seen: true) }
  end

  def has_friendship_with? friend
    self.friendships.find_by_friend_id friend
  end

  def is_friends_with? friend
    self.accepted_friendships.find_by_friend_id friend
  end

  def sent_friendship_request_to? friend
    self.pending_friendships.find_by_friend_id friend
  end

  def has_friendship_request_from? friend
    self.requested_friendships.find_by_friend_id friend
  end

  def send_friend_request_notification(user)
    self.notifications.build( seen: false,
                              tunnel: "/users/#{user.id}",
                              body: "#{user.name} has sent you a friend request.")
    self.save(validate: false)
  end

  def send_friend_acceptance_notification(user)
    self.notifications.build( seen: false,
                              tunnel: "/users/#{user.id}",
                              body: "You are now friends with #{user.name}!")
    self.save(validate: false)
  end

  def destroy_complementary_friendships
    Friendship.destroy_all(friend_id: self.id)
  end
end
