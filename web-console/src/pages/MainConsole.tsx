import { useState } from "react"


export default function MainConsole(){
    const [doubleView, setDoubleView] = useState<bool>(false)
    
    const [elements, setElements] = useState<React.ReactElement[]>([])



    return (
        <>


        {elements.map((element) => ({element}))}
        </>
    )
}