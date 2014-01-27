class Listing < ActiveRecord::Base

  belongs_to :user
  has_many :services
  has_many :applicants

  validates :title, :description, :price, :positions, :category, :audience, presence: true
  validates :positions, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :can_afford_listing?
  validate :start_end_time_validations

  before_save :default_values
  before_save :update_status

  def is_active?
    self.status == 'active'
  end

  def for_a_service?
    self.category == 'customer'
  end

  def provides_a_service?
    self.category == 'provider'
  end

  def self.audiences
    ['everyone', 'friends']
  end

  def self.categories
    ['customer', 'provider']
  end

  def fill_position
    self.positions -= 1
    if self.positions == 0
      self.status = 'inactive'
    end
    self.save!
  end

  def open_position
    if self.positions == 0
      self.status == 'active'
    end
    self.positions += 1
    self.save!
  end

  def live_services
    self.services.where.not(status: 'inactive')
  end

  # def open_positions_count
  #   self.positions.to_i - self.live_services.count
  # end

  private

  def default_values
    self.status ||= 'active'
    self.positions ||= 1
  end

  def update_status
    if self.positions == 0 # or self.positions <= self.live_services.count
      self.status = 'inactive'
    end
  end

  def can_afford_listing?
    balance_difference = self.user.balance.to_i - (self.price.to_i * self.positions.to_i)
    if balance_difference < 0
      errors.add(:price, "Your balance must be atleast #{balance_difference.abs} to create this listing")
    end
  end

  def start_end_time_validations
    self.start_time ||= Time.now
    self.end_time ||= self.start_time + 7.days
    errors.add(:start_time, "must be before end time") unless
     self.start_time <= self.end_time
  end 

end
