module Admin
  class AppointmentsController < ApplicationController
    def index
      @appointments = Appointment.all
    end

    def show
      @appointment = Appointment.find(params[:id])
    end

    def new
      @appointment = Appointment.new
    end

    def create
      @appointment = Appointment.new(appointment_params)
      if @appointment.save
        redirect_to admin_appointment_path(@appointment), notice: "Appointment created successfully."
      else
        render :new
      end
    end

    def edit
      @appointment = Appointment.find(params[:id])
    end

    def update
      @appointment = Appointment.find(params[:id])
      if @appointment.update(appointment_params)
        redirect_to admin_appointment_path(@appointment), notice: "Appointment updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @appointment = Appointment.find(params[:id])
      @appointment.destroy
      redirect_to admin_appointments_path, notice: "Appointment deleted successfully."
    end

    private

    def appointment_params
      params.require(:appointment).permit(:patient_id, :doctor_id, :scheduled_at, :status, :notes)
      # Adjust permitted parameters based on your Appointment model.
    end
  end
end
