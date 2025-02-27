class Doctor < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :appointments
  has_many :patients,dependent: :destroy,through: :appointments
  has_many :prescriptions,through: :patients

  




  validates :first_name, :last_name, :license_no, :phone_number, :education, presence: true
  validates :license_no, uniqueness: true
  validates :phone_number, numericality: { only_integer: true }, length: { is: 10 }
end
