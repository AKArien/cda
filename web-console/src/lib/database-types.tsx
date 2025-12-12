// public interfaces to records and types from database

// point and perimeter type to interface with postgres geographic types
export type point = {
    x: number
    y: number
}

export type path = {
    points: point[]
    closed: boolean
}

// types mimicking tables
export interface access {
    name: number
    expires: Date
    max_session_time: number
    force_change_pass: boolean
}

export interface sites {
    name: string
    info: string
    perimeter: path
}