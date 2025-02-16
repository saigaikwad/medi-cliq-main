class Patient < ApplicationRecord
  has_many :prescriptions, dependent: :destroy
  accepts_nested_attributes_for :prescriptions
  #belongs_to :doctor, through: :appointments

  has_many :appointments
  has_many :doctors, through: :appointments
  

  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
