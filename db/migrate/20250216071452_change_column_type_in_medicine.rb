class ChangeColumnTypeInMedicine < ActiveRecord::Migration[6.0]
  def change
    change_column :medicines, :quantity, :integer, using: 'quantity::integer'
  end
end
