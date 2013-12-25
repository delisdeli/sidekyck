class AddTunnelToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :tunnel, :string
  end
end
