class AppointmentNotificationJob < ApplicationJob
  queue_as :default

  

  def perform(appointment_id, room_name)
    Rails.logger.info "🚀 Sending notification for appointment #{appointment_id}"

    appointment = Appointment.find_by(id: appointment_id)
    return Rails.logger.info "❌ Appointment not found!" unless appointment

    patient = appointment.patient
    return Rails.logger.info "❌ Patient not found!" unless patient

    # Send WebSocket notification
    NotificationChannel.broadcast_to(
      patient,
      { message: "Your doctor has started a video call. Click here to join.", room_name: room_name }
    )

    Rails.logger.info "✅ Notification sent successfully!"
  end
end
