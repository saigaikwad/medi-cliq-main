module Admin
  class PrescriptionsController < ApplicationController
    def index
      @prescriptions = Prescription.all
    end

    def show
      @prescription = Prescription.find(params[:id])
    end

    def new
      @prescription = Prescription.new
    end

    def create
      @prescription = Prescription.new(prescription_params)
      if @prescription.save
        redirect_to admin_prescription_path(@prescription), notice: "Prescription created successfully."
      else
        render :new
      end
    end

    def edit
      @prescription = Prescription.find(params[:id])
    end

    def update
      @prescription = Prescription.find(params[:id])
      if @prescription.update(prescription_params)
        redirect_to admin_prescription_path(@prescription), notice: "Prescription updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @prescription = Prescription.find(params[:id])
      @prescription.destroy
      redirect_to admin_prescriptions_path, notice: "Prescription deleted successfully."
    end

    private

    def prescription_params
      params.require(:prescription).permit(:patient_id, :doctor_id, :medicine_details, :dosage, :instructions)
      # Adjust permitted parameters based on your Prescription model attributes.
    end
  end
end

