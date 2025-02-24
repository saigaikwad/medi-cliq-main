class AdminUser < ApplicationRecord
  self.table_name = 'admins'
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  before_validation :downcase_email

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
