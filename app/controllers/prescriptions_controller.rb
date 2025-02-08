class PrescriptionsController < ApplicationController
  before_action :authenticate_doctor!

  def index
    
    @prescriptions = Prescription.includes(:patient, :medicine, :doctor).where(patients: {doctor_id: current_doctor.id})
   # @prescriptions = current_patient.prescriptions
  end

  def show
    @prescription = Prescription.find(params[:id])
  end
end
