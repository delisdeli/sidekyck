class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.references :listing, index: true
      t.integer :applicant_id

      t.timestamps
    end
  end
end
