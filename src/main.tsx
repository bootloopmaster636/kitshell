import React from "react";
import ReactDOM from "react-dom/client";
import "./main.css";
import { BrowserRouter, Route, Routes } from "react-router";
import MainScreen from "./screens/panel/main_panel";
import PopUp from "./screens/popup/popup";
import CalendarPopup from "./screens/popup/widgets/calendar/calendar_popup";

ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        // Panel
        <Route path="/" element={<MainScreen />} />
        // Popups
        <Route path="/popup" element={<PopUp />} />
        <Route path="/calendar" element={<CalendarPopup />} />
      </Routes>
    </BrowserRouter>
  </React.StrictMode>,
);
