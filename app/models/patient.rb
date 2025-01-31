class Patient < ApplicationRecord
  has_many :prescriptions, dependent: :destroy
  accepts_nested_attributes_for :prescriptions
  

  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
