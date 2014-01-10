class Applicant < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user
end
