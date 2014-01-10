class Listing < ActiveRecord::Base

  belongs_to :user
  has_many :services
  has_many :applicants

  validates :positions, numericality: { only_integer: true }
  before_save :initialize_listing

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

  private

  def initialize_listing
    (self.status = 'active') if self.status.nil?
  end

end
