class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :body
      t.references :user, index: true
      t.boolean :seen

      t.timestamps
    end
  end
end
