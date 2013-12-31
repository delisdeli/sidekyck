class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
      t.string :uid
      t.references :user, index: true

      t.timestamps
    end
  end
end
