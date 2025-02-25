class Prescription < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor
  belongs_to :medicine
  has_one :qr
  after_create :generate_qr_code

  private

  def generate_qr_code
    qr_data = {
      medicine_id: medicine.id,
      quantity: prescription_quantity
    }.to_json

    qr_code = RQRCode::QRCode.new(qr_data).as_svg(module_size: 6)

    created_qr = Qr.create(prescription_id: id, qr_code: qr_code)

    # Now use the created Qr record
    qr_data = {
      qr_id: created_qr.id,
      medicine_id: medicine.id,
      quantity: prescription_quantity
    }.to_json

    # Update the QR code with the proper `qr_id`
    created_qr.update(qr_code: RQRCode::QRCode.new(qr_data).as_svg(module_size: 6))
  end
end
