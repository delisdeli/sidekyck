class AddAudienceToListings < ActiveRecord::Migration
  def change
    add_column :listings, :audience, :string
  end
end
