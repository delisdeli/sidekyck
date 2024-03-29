class User < ActiveRecord::Base

  has_many :providers, dependent: :destroy
  has_many :notifications,  dependent: :destroy
  
  has_many :friendships,  dependent: :delete_all
  has_many :accepted_friendships, -> { where status: 'accepted'}, class_name: "Friendship"
  has_many :requested_friendships, -> { where status: 'requested'}, class_name: "Friendship"
  has_many :pending_friendships, -> { where status: 'pending'}, class_name: "Friendship"
  has_many :friends, through: :accepted_friendships
  has_many :requested_friends, through: :requested_friendships, :source => :friend
  has_many :pending_friends, through: :pending_friendships, :source => :friend
  
  has_many :applicants, dependent: :destroy

  has_many :listings
  # has_many :services
  # has_many :requested_services, -> { where type: 'requested'}, class_name: "Services"
  # has_many :service_providers, through: :requested_services, source: :provider
  # has_many :provided_services, -> { where type: 'provided'}, class_name: "Services"
  # has_many :customers, through: :provided_services


  before_save :restrict_max_notifications
  before_destroy :destroy_complementary_friendships

  def add_provider(auth)
    provider = self.providers.build(name: auth["provider"], uid: auth["uid"])
    if auth["credentials"]
      provider.oauth_token = auth["credentials"]["token"]
      if auth["credentials"]["expires_at"]
        provider.oauth_expires_at = Time.at(auth["credentials"]["expires_at"])
      end
    end
    self.save!
  end

  def has_provider? provider
    !!providers.find_by_name(provider)
  end

  def has_multiple_providers?
    providers.count > 1
  end

  def has_friend_requests?
    !requested_friendships.empty?
  end

  def is_user? user
    self == user
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

  def active_listings
    listings.where(status: 'active')
  end

  def nonactive_listings
    listings.where.not(status: 'active')
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

  def can_apply_for_listing? listing
    !is_user?(listing.user) and listing.is_active? and (listing.audience == 'everyone' or
      (is_friends_with? listing.user and listing.audience == 'friends'))
  end

  def applied_to_listing? listing
    !!listing.applicants.find_by_user_id(self.id)
  end

  def friends_friend_listings
    listings_to_display = []
    self.friends.each do |friend|
      listings_to_display += friend.listings.where(status: 'active', audience: 'friends')
    end
    listings_to_display
  end

  def destroy_complementary_friendships
    Friendship.destroy_all(friend_id: self.id)
  end

  def active_requested_services
    Service.where(status: 'active', customer_id: self.id)
  end

  def active_provided_services
    Serivce.where(status: 'active', provider_id: self.id)
  end

  def active_serices
    active_requested_services + active_provided_services
  end

end
