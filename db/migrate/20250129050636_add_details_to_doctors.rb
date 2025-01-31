class AddDetailsToDoctors < ActiveRecord::Migration[7.1]
  def change
    add_column :doctors, :first_name, :string
    add_column :doctors, :last_name, :string
    add_column :doctors, :license_no, :string
    add_column :doctors, :phone_number, :string
    add_column :doctors, :education, :string
  end
end
