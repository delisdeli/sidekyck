class AddOauthTokenAndOauthExpiresAtToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :oauth_token, :string
    add_column :providers, :oauth_expires_at, :date_time
  end
end
