class PrescriptionsController < ApplicationController
  before_action :authenticate_doctor!

  def index
    
    @prescriptions = Prescription.includes(:patient, :medicine, :doctor).all
   # @prescriptions = current_patient.prescriptions
  end

  def show
    @prescription = Prescription.find(params[:id])
  end
end
