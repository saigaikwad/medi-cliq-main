class NotificationChannel < ApplicationCable::Channel
  def subscribed
    if current_patient
      stream_for current_patient
    else
      reject_unauthorized_connection
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
