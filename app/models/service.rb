class Service < ActiveRecord::Base
  belongs_to :listing
  belongs_to :customer, :class_name => "User"
  belongs_to :provider, :class_name => "User"
end
