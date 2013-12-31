class Provider < ActiveRecord::Base
  belongs_to :user

  def self.find_with_omniauth(auth)
    Provider.find_by_name_and_uid(auth["provider"], auth["uid"])
  end

end
