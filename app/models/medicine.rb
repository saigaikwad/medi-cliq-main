class Medicine < ApplicationRecord
  belongs_to :category

  validates :name, :exp_date, :form, :manufacturer, :batch_no, :quantity, :price, presence: true
  def self.ransackable_attributes(auth_object = nil)
    %w[name exp_date form manufacturer batch_no prescribed quantity price]
  end
end
