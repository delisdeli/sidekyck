class Listing < ActiveRecord::Base

  belongs_to :user
  has_many :services
  has_many :applications

  validates :positions, numericality: { only_integer: true }
  before_save :initialize_listing

  private

  def initialize_listing
    (self.status = 'active') if self.status.nil?
  end

end
