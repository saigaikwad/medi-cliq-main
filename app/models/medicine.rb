class Medicine < ApplicationRecord
  belongs_to :category
  has_many :prescriptions
  validates :batch_no, uniqueness: { scope: :name, message: "already exists for this medicine" }

end
