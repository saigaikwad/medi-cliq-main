class AddPasswordDigestToAdminUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_users, :password_digest, :string
  end
end
