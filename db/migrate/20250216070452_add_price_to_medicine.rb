class AddPriceToMedicine < ActiveRecord::Migration[7.1]
  def change
    add_column :medicines, :price, :decimal
  end
end
