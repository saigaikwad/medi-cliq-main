import React from "react";
import { createRoot } from "react-dom/client";
import DoctorDashboard from "../components/DoctorDashboard";

document.addEventListener("DOMContentLoaded", () => {
  const rootElement = document.getElementById("root");

  if (rootElement) {
    // Extract props from the data attributes
    const doctor = JSON.parse(rootElement.dataset.doctor);
    const appointments = JSON.parse(rootElement.dataset.appointments);

    // Mount the React component
    createRoot(rootElement).render(<DoctorDashboard doctor={doctor} appointments={appointments} />);
  }
});
