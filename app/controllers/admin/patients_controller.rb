module Admin
  class PatientsController < ApplicationController
    before_action :authenticate_admin_user! # Ensures only admins can access
    before_action :set_patient, only: %i[show edit update destroy]

    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

    # ✅ LIST ALL PATIENTS (with search & pagination)
    def index
      @q = Patient.ransack(params[:q]) # Ransack for search functionality
      @patients = @q.result.order(created_at: :desc).page(params[:page])
    end


    # ✅ SHOW A SINGLE PATIENT
    def show; end

    # ✅ NEW PATIENT FORM
    def new
      @patient = Patient.new
    end

    # ✅ CREATE A NEW PATIENT
    def create
      @patient = Patient.new(patient_params)
      if @patient.save
        redirect_to admin_patient_path(@patient), notice: "✅ Patient created successfully."
      else
        flash.now[:alert] = " Unable to create patient. Please check the errors below."
        render :new, status: :unprocessable_entity
      end
    end

    # ✅ EDIT PATIENT FORM
    def edit; end

    # ✅ UPDATE PATIENT DETAILS
    def update
      if @patient.update(patient_params)
        redirect_to admin_patient_path(@patient), notice: "✅ Patient updated successfully."
      else
        flash.now[:alert] = " Unable to update patient. Please check the errors below."
        render :edit, status: :unprocessable_entity
      end
    end

    # ✅ DELETE PATIENT
    def destroy
      if @patient.destroy
        redirect_to admin_patients_path, notice: " Patient deleted successfully."
      else
        redirect_to admin_patients_path, alert: " Unable to delete patient. It might have dependent records."
      end
    end

    private

    # 🔍 FIND PATIENT (Used in `show`, `edit`, `update`, `destroy`)
    def set_patient
      @patient = Patient.find_by!(id: params[:id])
    end

    # HANDLE RECORD NOT FOUND ERROR
    def handle_not_found
      redirect_to admin_patients_path, alert: " Patient not found."
    end

    # STRONG PARAMETERS
    def patient_params
      params.require(:patient).permit(:name, :email, :phone, :address,:dob, :medical_history)
    end
  end
end
