class AddDeletedAtToPatients < ActiveRecord::Migration[7.1]
  def change
    add_column :patients, :deleted_at, :datetime
  end
end
