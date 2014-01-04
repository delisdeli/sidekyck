class Application < ActiveRecord::Base
  belongs_to :listing
  belongs_to :applicant, class_name: "User"
end
