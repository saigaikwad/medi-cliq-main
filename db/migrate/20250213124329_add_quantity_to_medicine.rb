class AddQuantityToMedicine < ActiveRecord::Migration[7.1]
  def change
    add_column :medicines, :quantity, :string
  end
end
