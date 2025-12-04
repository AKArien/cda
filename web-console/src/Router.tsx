import { Route, Routes } from "react-router";

import Home from "./pages/Home";
import Login from "./pages/Login";
import _404 from "./pages/errors/404";


export default function Router() {
  return (
    <>
      <Routes>
        <Route index element={<Home />} />
        <Route path="/login" element={<Login />} />
        <Route path="*" element={<_404 />} />
      </Routes>
    </>
  );
}
