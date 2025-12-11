// public interfaces to records and types from database

export interface access {
    name: number
    expires: Date
    max_session_time: number
    force_change_pass: boolean
}