import React, { useState } from "react";
import {
  AppBar,
  Toolbar,
  Typography,
  IconButton,
  Drawer,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Button,
} from "@mui/material";
import {
  Menu as MenuIcon,
  PersonAdd as PersonAddIcon,
  People as PeopleIcon,
  Medication as MedicationIcon,
  Event as EventIcon,
  ExitToApp as ExitToAppIcon,
} from "@mui/icons-material";

const DoctorDashboard = ({ doctor, appointments }) => {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  const toggleSidebar = () => {
    setSidebarOpen(!sidebarOpen);
  };

  return (
    <div style={{ display: "flex" }}>
      <AppBar position="fixed" sx={{ bgcolor: "#1976d2" }}>
        <Toolbar>
          <IconButton edge="start" color="inherit" onClick={toggleSidebar}>
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" sx={{ flexGrow: 1 }}>
            Doctor Dashboard
          </Typography>
        </Toolbar>
      </AppBar>

      <Drawer anchor="left" open={sidebarOpen} onClose={toggleSidebar}>
        <List sx={{ width: 250 }}>
          <ListItem button component="a" href={`/doctors/${doctor.id}/patients/new`}>
            <ListItemIcon>
              <PersonAddIcon />
            </ListItemIcon>
            <ListItemText primary="Create Patient" />
          </ListItem>
          <ListItem button component="a" href={`/doctors/${doctor.id}/patients`}>
            <ListItemIcon>
              <PeopleIcon />
            </ListItemIcon>
            <ListItemText primary="View Patients" />
          </ListItem>
          <ListItem button component="a" href="/medicines">
            <ListItemIcon>
              <MedicationIcon />
            </ListItemIcon>
            <ListItemText primary="Available Medicines" />
          </ListItem>
          <ListItem button component="a" href="/appointments">
            <ListItemIcon>
              <EventIcon />
            </ListItemIcon>
            <ListItemText primary="Appointments" />
          </ListItem>
          <ListItem
            button
            component="a"
            href="/doctors/sign_out"
            data-turbo-method="delete"
            sx={{ color: "red" }}
          >
            <ListItemIcon sx={{ color: "red" }}>
              <ExitToAppIcon />
            </ListItemIcon>
            <ListItemText primary="Logout" />
          </ListItem>
        </List>
      </Drawer>

      <main style={{ flexGrow: 1, padding: "80px 20px" }}>
        <Typography variant="h4" gutterBottom>
          Appointments
        </Typography>

        <TableContainer component={Paper} sx={{ maxWidth: 800 }}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell><strong>Patient</strong></TableCell>
                <TableCell><strong>Date</strong></TableCell>
                <TableCell><strong>Status</strong></TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {appointments.map((appointment) => (
                <TableRow key={appointment.id}>
                  <TableCell>{appointment.patient.name}</TableCell>
                  <TableCell>{new Date(appointment.date).toLocaleString()}</TableCell>
                  <TableCell>
                    <Button
                      variant="contained"
                      size="small"
                      sx={{
                        backgroundColor: appointment.status === "confirmed" ? "green" : "orange",
                        color: "white",
                      }}
                    >
                      {appointment.status.toUpperCase()}
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TableContainer>
      </main>
    </div>
  );
};

// ✅ Make sure it is properly exported
export default DoctorDashboard;
