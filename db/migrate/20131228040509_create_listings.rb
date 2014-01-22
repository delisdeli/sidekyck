class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :price
      t.text :description
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.string :status
      t.integer :positions

      t.timestamps
    end
  end
end
