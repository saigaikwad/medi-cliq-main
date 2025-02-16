class AppointmentsController < ApplicationController
  before_action :authenticate_patient!, only: [:new, :create]
  before_action :authenticate_doctor!, only: [:index, :update]
  before_action :set_appointment, only: [:show, :confirm, :cancel, :start_video_call] # Ensure it runs for `start_video_call`


  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = current_patient.appointments.build(appointment_params)
    @appointment.status = "pending"

    if @appointment.save
      redirect_to patients_dashboard_path, notice: "Appointment request sent to doctor."
    else
      render :new
    end
  end

  def index
    if current_doctor
      @appointments = current_doctor.appointments
    elsif current_patient
      @appointments = current_patient.appointments
    else
      redirect_to root_path, alert: "Access denied."
    end
  
  end

  def update
    @appointment = Appointment.find(params[:id])
    if params[:status].present?
      @appointment.update(status: params[:status])
      redirect_to appointments_path, notice: "Appointment status updated."
    else
      redirect_to appointments_path, alert: "Invalid status."
    end
  end

  

  def show
    @appointment = Appointment.find(params[:id])
  end
  
  def confirm
    @appointment = Appointment.find(params[:id])
    if @appointment.update(status: "confirmed")
      respond_to do |format|
        format.html { redirect_to appointments_path, notice: "Appointment confirmed successfully." }
        format.js   # This will render confirm.js.erb
      end
    else
      redirect_to appointments_path, alert: "Failed to update appointment."
    end
  end

  def cancel
    @appointment = Appointment.find(params[:id])
    if @appointment.update(status: "cancelled")
      respond_to do |format|
        format.html { redirect_to appointments_path, notice: "Appointment cancelled." }
        format.js
      end
    else
      redirect_to appointments_path, alert: "Failed to cancel appointment."
    end
  end

  def start_video_call
    @appointment = Appointment.find_by(id: params[:id])
    
    if @appointment
      @room_name = "video_call_#{@appointment.id}"
    else
      redirect_to appointments_path, alert: "Appointment not found."
    end
  end
  
  private

  def set_appointment
    @appointment = Appointment.find_by(id: params[:id])
    unless @appointment
      flash[:alert] = "Appointment not found."
      redirect_to appointments_path
    end
  end
  

  private

  def appointment_params
    params.require(:appointment).permit(:doctor_id, :date)
  end


 
end
