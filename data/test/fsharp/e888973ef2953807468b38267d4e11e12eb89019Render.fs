module Render


open System

open Agent
open Environment


let renderAgent agent =
    match agent.Orientation with
    | North -> "^"
    | South -> "v"
    | East -> ">"
    | West -> "<"
    

let render world agent =
    Console.Clear();
    
    let map = Array2D.copy world.Map
    let tileSave1 = map.[world.Home.Y, world.Home.X]
    let tileSave2 = map.[agent.Position.Y, agent.Position.X]
    map.[world.Home.Y, world.Home.X] <- "H"
    map.[agent.Position.Y, agent.Position.X] <- renderAgent agent
    
    Array2D.mapi (fun i j element -> map.[(map.GetLength 0) - 1 - i, j]) map 
    |> printfn "%A"
    printfn "%A" agent.Performance

    ()


