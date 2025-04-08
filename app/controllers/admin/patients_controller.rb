module Admin
  class PatientsController < ApplicationController
    before_action :authenticate_admin_user!
    before_action :set_patient, only: [:show, :authenticate, :lock]

    def index
      @patients = Patient.all
    end

    def show
      @authenticated = session["admin_patient_authenticated_#{@patient.id}"]
    end

    def authenticate
      if current_admin_user.valid_password?(params[:admin_password])
        session["admin_patient_authenticated_#{@patient.id}"] = true
        redirect_to admin_patient_path(@patient), notice: "Patient data unlocked."
      else
        flash.now[:alert] = "Invalid admin password."
        @authenticated = false
        render :show, status: :unauthorized
      end
    end

    def lock
      session.delete("admin_patient_authenticated_#{@patient.id}")
      redirect_to admin_patient_path(@patient), notice: "Patient data locked again."
    end


    private

    def set_patient
      @patient = Patient.find(params[:id])
    end
  end
end
