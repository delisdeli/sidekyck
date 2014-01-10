class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.references :listing, index: true
      t.integer :user_id

      t.timestamps
    end
  end
end
