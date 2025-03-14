import React from "react";
import ReactDOM from "react-dom/client";
import "./main.css";
import { BrowserRouter, Route, Routes } from "react-router";
import MainScreen from "./screens/panel/main_panel";
import PopUp from "./screens/popup/popup";

ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<MainScreen />} />
        <Route path="/popup" element={<PopUp />} />
      </Routes>
    </BrowserRouter>
  </React.StrictMode>,
);
