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
    # Check if a patient with the given email already exists
    existing_patient = Patient.find_by(email: patient_params[:email])
  
    if existing_patient
      # Use the existing patient
      @patient = existing_patient
  
      # Build a new prescription and assign attributes
      prescription = @patient.prescriptions.build(patient_params[:prescriptions_attributes].values.first)
      prescription.doctor_id = current_doctor.id
  
      if prescription.save
        redirect_to prescription_path(prescription), notice: "Existing patient found. Prescription added successfully!"
      else
        flash[:alert] = prescription.errors.full_messages.join(", ")
        render :new
      end
    else
    generated_password = SecureRandom.hex(8) # Generate a random password
    @patient = Patient.new(patient_params)
    @patient.doctor_id = current_doctor.id
    @patient.password = generated_password
    @patient.password_confirmation = generated_password
  
    # Assign doctor_id to each prescription before saving
    @patient.prescriptions.each { |p| p.doctor_id = current_doctor.id }
  
    if @patient.save
      # Fetch the latest prescription associated with this patient
      prescription = @patient.prescriptions.last 
      
      # Send login details to patient via email
      PatientMailer.send_login_details(@patient, generated_password).deliver_now
  
      # Redirect to the specific prescription's show page
      redirect_to prescription_path(prescription), notice: "Patient & Prescription created successfully!"
    else
      puts @patient.errors.full_messages  # Debugging
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
