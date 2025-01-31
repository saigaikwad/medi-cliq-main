class Prescription < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor
  belongs_to :medicine
  has_one :qr
  after_create :generate_qr_code

  private

  def generate_qr_code
    qr_data = {
      patient_name: patient.name,
      medicine_id: medicine.id,
      quantity: prescription_quantity
    }.to_json

    qr = RQRCode::QRCode.new(qr_data)
    qr_svg = qr.as_svg(module_size: 6)

    Qr.create(prescription_id: id, qr_code: qr_svg)
  end
end
