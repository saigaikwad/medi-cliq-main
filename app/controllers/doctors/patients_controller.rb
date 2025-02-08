class Doctors::PatientsController < ApplicationController
  before_action :authenticate_doctor! # Ensure only doctors can create patients & prescriptions

  def new
    @patient = Patient.new
    @patient.prescriptions.build
  end

  def index
    @patients = current_doctor.patients
  end

  

  def create
    generated_password = SecureRandom.hex(8) # Generate a random password
    @patient = Patient.new(patient_params)
    @patient.doctor_id = current_doctor.id

    @patient.password = generated_password
    @patient.password_confirmation = generated_password

    if @patient.save
      # Fetch the latest prescription associated with this patient
      prescription = @patient.prescriptions.last 
    
      # Send login details to patient via email
      PatientMailer.send_login_details(@patient, generated_password).deliver_now
    
      # Redirect to the specific prescription's show page
      redirect_to prescription_path(prescription), notice: "Patient & Prescription created successfully!"
    else
      puts @patient.errors.full_messages  # Add this line for debugging
      flash[:alert] = @patient.errors.full_messages.join(", ") 
      render :new

    end
  end

  private

  def patient_params
    params.require(:patient).permit(
      :name, :age, :gender, :address, :phone, :email,:doctor_id,
      prescriptions_attributes: [:doctor_id, :medicine_id, :dosage_description, :prescription_quantity, :duration]
    )
  end
end
