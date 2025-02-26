class Patient < ApplicationRecord
  has_many :prescriptions, dependent: :destroy
  accepts_nested_attributes_for :prescriptions
  #belongs_to :doctor, through: :appointments

  has_many :appointments
  has_many :doctors, through: :appointments

      def self.ransackable_attributes(auth_object = nil)
      ["name", "email", "phone", "address", "created_at", "updated_at", "dob", "medical_history"]
    end
  def self.ransackable_associations(auth_object = nil)
    ["doctor"] # Add any other related models that need to be searchable
  end

  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
