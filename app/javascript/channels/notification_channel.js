// app/javascript/channels/notification_channel.js
import consumer from "./consumer";

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    console.log("Connected to NotificationChannel");
  },

  received(data) {
    console.log("Received notification:", data);
  }
});
