interface RetData {
    token: string
    session_time: number
}

export async function login(access: string, pass: string, req_dur = 3600): Promise<Response>{
    const headers: Headers = new Headers()
    headers.set("Content-Type", "application/json")

    const res = await fetch(
        "https://localhost:3000/rpc/login",
        {
            method: "POST",
            headers: headers,
            body: JSON.stringify(
                {
                    access: access,
                    pass: pass,
                    requested_session_time: req_dur
                }
            )
        }
    )

    if (res.ok){
        const resp = await res.json() as RetData
        const exp = (new Date(new Date().getTime() + resp.session_time))

        document.cookie =
            "session="
            + resp.token
            + "; expires="
            + exp.toUTCString()
            + "; path=/auth"
    }

    return res
}