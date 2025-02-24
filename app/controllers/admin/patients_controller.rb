module Admin
  class PatientsController < ApplicationController
    # before_action :authenticate_admin!  # if you add admin auth

    def index
      @patients = Patient.all
    end

    def show
      @patient = Patient.find(params[:id])
    end

    def new
      @patient = Patient.new
    end

    def create
      @patient = Patient.new(patient_params)
      if @patient.save
        redirect_to admin_patient_path(@patient), notice: "Patient created successfully."
      else
        render :new
      end
    end

    def edit
      @patient = Patient.find(params[:id])
    end

    def update
      @patient = Patient.find(params[:id])
      if @patient.update(patient_params)
        redirect_to admin_patient_path(@patient), notice: "Patient updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @patient = Patient.find(params[:id])
      if @patient.destroy
        redirect_to admin_patients_path, notice: "Patient deleted successfully."
      else
        redirect_to admin_patients_path, alert: "Unable to delete patient. It might have dependent records."
      end
    end

    private

    def patient_params
      params.require(:patient).permit(:name, :email, :phone, :address) # Adjust permitted params as needed
    end
  end
end
