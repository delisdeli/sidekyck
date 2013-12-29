class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.decimal :price
      t.text :instructions
      t.string :title
      t.time :start_time
      t.time :end_time
      t.text :requirements
      t.string :status

      t.timestamps
    end
  end
end
