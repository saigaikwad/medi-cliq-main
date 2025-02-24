# frozen_string_literal: true

class AddDeviseToAdmins < ActiveRecord::Migration[7.1]
  def self.up
    change_table :admins do |t|
      ## Database authenticatable
      # t.string :email,              null: false, default: ""   # Already exists
      # t.string :encrypted_password, null: false, default: ""   # Already exists

      ## Recoverable
      unless column_exists?(:admins, :reset_password_token)
        t.string   :reset_password_token
      end
      unless column_exists?(:admins, :reset_password_sent_at)
        t.datetime :reset_password_sent_at
      end

      ## Rememberable
      unless column_exists?(:admins, :remember_created_at)
        t.datetime :remember_created_at
      end

      ## Trackable
      # Uncomment if needed:
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false
      # t.string   :unlock_token
      # t.datetime :locked_at

      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps null: false
    end

    add_index :admins, :email, unique: true unless index_exists?(:admins, :email)
    add_index :admins, :reset_password_token, unique: true unless index_exists?(:admins, :reset_password_token)
    # add_index :admins, :confirmation_token, unique: true
    # add_index :admins, :unlock_token, unique: true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
