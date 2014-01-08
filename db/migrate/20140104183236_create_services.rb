class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.references :listing, index: true
      t.string :status
      t.datetime :start_time
      t.datetime :completion_time
      t.integer :customer_id
      t.integer :provider_id
      t.text :notes

      t.timestamps
    end
  end
end
