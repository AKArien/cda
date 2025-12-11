import type { sites } from "../database-types"

export async function get_available_sites(): Promise<sites[]>{
    const headers: Headers = new Headers()
    headers.set("Content-Type", "application/json")
    headers.set(
        "Authorization", "Bearer "
        + document.cookie.split("; ").find((row) => row.startsWith("session"))?.split("=")[1])

    const res = await fetch(
        "https://localhost:3000/sites",
        {
            method: "GET",
            headers: headers,
        }
    )

    if (res.ok){
        const resp = await res.json() as sites[]
        return resp
    }

    throw new Error()
}