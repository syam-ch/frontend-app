import React from "react";
import ReactDOM from "react-dom/client";
import App from "./app";
import "./index.css"; // optional, if you want global styles

// Get the root div from public/index.html
const root = ReactDOM.createRoot(document.getElementById("root"));

// Render the App component inside the root div
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
