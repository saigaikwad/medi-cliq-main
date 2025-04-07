class PrescriptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    if doctor_signed_in?
      # Doctor can see prescriptions for their patients
      @prescriptions = Prescription.includes(:patient, :medicine, :doctor)
                                   .where(patients: { doctor_id: current_doctor.id })
    elsif patient_signed_in?
      # Patient can only see their own prescriptions
      @prescriptions = current_patient.prescriptions.includes(:medicine, :doctor)
    else
      redirect_to root_path, alert: "You are not authorized to view this page."
    end
  end

  def show
    @prescription = Prescription.find(params[:id])

    # Ensure only the assigned doctor or the patient can view the prescription
    if doctor_signed_in? && @prescription.doctor_id == current_doctor.id
      # Doctor can view
    elsif patient_signed_in? && @prescription.patient_id == current_patient.id
      # Patient can view
    else
      redirect_to root_path, alert: "Access Denied!"
    end
  end
end
