import { useEffect, useState } from "react";
import { useNavigate } from "react-router";
import { login } from "../lib/auth/login";
import { session_access } from "../lib/auth/session_access";

export default function Login(){
    const [error, setError] = useState<string | null>(null);
    const navigate = useNavigate();

    async function handleSubmit(e: React.FormEvent<HTMLFormElement>){
        e.preventDefault()
        const formData = new FormData(e.currentTarget)
        const access = formData.get("access") as string
        const pass = formData.get("pass") as string
        try {
            await login(access, pass)
            void navigate("/console")
        }
        catch (e) {
            setError(e as string)
        }
    }

    useEffect(() => {
        (async () => {
            const access = await session_access()
            if (access) {
                void navigate("/");
            }
        })()
    }, [navigate]);

    return (
        <form onSubmit={handleSubmit}>
            {error ? <div className="error">{error}</div> : null}
            <label htmlFor="access">Access</label>
            <input
                name="access"
                type="text"
                placeholder="Access as given by your organisation"
                required
            />
            <label htmlFor="pass">Passphrase</label>
            <input
                name="pass"
                type="password"
                placeholder="password"
                required
            />
            <label htmlFor="req_dur">Stay logged in for:</label>
            <input
                name="req_dur"
                type="number"
            />
        </form>
    )
}