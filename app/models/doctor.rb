class Doctor < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Associations
  has_many :appointments, dependent: :nullify
  has_many :patients, dependent: :nullify
  has_many :prescriptions, dependent: :nullify

  # Validations
  validates :first_name, :last_name, :license_no, :phone_number, :education, presence: true
  validates :license_no, uniqueness: true
  validates :phone_number, numericality: { only_integer: true }, length: { is: 10 }

  # Full name method for display
  def name
    "#{first_name} #{last_name}"
  end
end
