import { useEffect } from "react";
import { useNavigate } from "react-router";

import { session_access } from "../lib/auth/session_access";


export default function Home(){
    const navigate = useNavigate();

    useEffect(() => {
        (async () => {
            const access = await session_access()
            if (!access) {
                void navigate("/login");
            }
        })()
    }, [navigate]);

    return (
        <>
        Home sweet home
        </>
    )
}