class Prescription < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor
  belongs_to :medicine
  has_one :qr
  after_create :generate_qr_code
  validates :doctor_id, presence: true

  private

  def generate_qr_code
    prescriptions = patient.prescriptions.includes(:medicine)

    qr_data = prescriptions.map do |prescription|
      {
        medicine_id: prescription.medicine.id,
        
        quantity: prescription.prescription_quantity,
   
      }
    end

    qr_code_data = {
      patient_id: patient.id,
      
      medicines: qr_data
    }.to_json

    qr_code_svg = RQRCode::QRCode.new(qr_code_data).as_svg(module_size: 6)

    if qr.present?
      qr.update(qr_code: qr_code_svg)
    else
      Qr.create(prescription_id: id, qr_code: qr_code_svg)
    end
  end
end
