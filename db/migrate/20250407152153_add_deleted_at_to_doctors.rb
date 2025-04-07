class AddDeletedAtToDoctors < ActiveRecord::Migration[7.1]
  def change
    add_column :doctors, :deleted_at, :datetime
    add_index :doctors, :deleted_at
  end
end
