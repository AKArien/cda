export async function logout(): Promise<Response>{
    const headers: Headers = new Headers()
    headers.set("Content-Type", "application/json")
    headers.set(
        "Authorization", "Bearer "
        + document.cookie.split("; ").find((row) => row.startsWith("session"))?.split("=")[1])

    const res = await fetch(
        "https://localhost:3000/rpc/logout",
        {
            method: "GET",
            headers: headers,
        }
    )

    if (res.ok){
        document.cookie = "session=; expires=0, path=/auth"
    }

    return res
}