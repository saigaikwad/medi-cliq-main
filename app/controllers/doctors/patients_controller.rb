class Doctors::PatientsController < ApplicationController
  before_action :authenticate_doctor! # Ensure only doctors can create patients & prescriptions

  def new
    @patient = Patient.new
    @patient.prescriptions.build
  end

  def index
    @patients = current_doctor.patients
  end




  def set_patient
    @patient = current_patient # Get the currently logged-in patient
  end

  

  def create
    # Check for existing patient by email or phone
    @patient = Patient.find_by(email: patient_params[:email]) || Patient.find_by(phone: patient_params[:phone])
  
    if @patient
      # If patient exists, just create a new prescription under this patient
      prescription = @patient.prescriptions.build(patient_params[:prescriptions_attributes]["0"])
      prescription.doctor_id = current_doctor.id
  
      if prescription.save
        redirect_to prescription_path(prescription), notice: "Prescription added to existing patient!"
      else
        flash[:alert] = prescription.errors.full_messages.join(", ")
        render :new
      end
    else
      # New patient path
      generated_password = SecureRandom.hex(8)
      @patient = Patient.new(patient_params)
      @patient.doctor_id = current_doctor.id
      @patient.password = generated_password
      @patient.password_confirmation = generated_password
  
      # Assign doctor_id to each prescription
      @patient.prescriptions.each { |p| p.doctor_id = current_doctor.id }
  
      if @patient.save
        prescription = @patient.prescriptions.last
        PatientMailer.send_login_details(@patient, generated_password).deliver_now
        redirect_to prescription_path(prescription), notice: "Patient & Prescription created successfully!"
      else
        puts @patient.errors.full_messages
        flash[:alert] = @patient.errors.full_messages.join(", ")
        render :new
      end
    end
  end
  

  private

  def patient_params
    params.require(:patient).permit(
      :name, :age, :gender, :address, :phone, :email,:doctor_id,:blood, :dob, :last_visited,
      prescriptions_attributes: [:doctor_id, :medicine_id, :dosage_description, :prescription_quantity, :duration]
    )
  end
end
