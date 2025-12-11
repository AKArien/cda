import type { access } from "./database-types"

export async function session_access(): Promise<access | null>{
    const headers: Headers = new Headers()
    headers.set("Content-Type", "application/json")
    headers.set(
        "Authorization", "Bearer "
        + document.cookie.split("; ").find((row) => row.startsWith("session"))?.split("=")[1])

    const res = await fetch(
        "https://localhost:3000/rpc/get_access_data",
        {
            method: "GET",
            headers: headers,
        }
    )

    if (res.ok){
        const resp = await res.json() as access
        return resp
    }

    return null
}