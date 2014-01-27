class AddHirePriceToServices < ActiveRecord::Migration
  def change
    add_column :services, :hire_price, :integer
  end
end
