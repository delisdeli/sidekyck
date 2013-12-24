class User < ActiveRecord::Base

  has_many :notifications
  has_many :friendships
  has_many :accepted_friendships, -> { where status: 'accepted'}, :class_name => "Friendship"
  has_many :requested_friendships, -> { where status: 'requested'}, :class_name => "Friendship"
  has_many :pending_friendships, -> { where status: 'pending'}, :class_name => "Friendship"
  has_many :friends, :through => :accepted_friendships
  has_many :requested_friends, :through => :requested_friendships, :source => :friend
  has_many :pending_friends, :through => :pending_friendships, :source => :friend
  
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :restrict_max_notifications

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def unseen_notifications
    self.notifications.where(seen: false)
  end

  def unseen_notifications_count
    self.unseen_notifications.size
  end

  def unseen_notifications?
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

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
