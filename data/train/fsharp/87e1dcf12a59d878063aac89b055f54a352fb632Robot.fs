namespace RobotWar.App

open System

type Facing =
    | North = 0
    | East = 1
    | South = 2
    | West = 3

module Robot =

    let StringToFacing (s: string) =
        match s.ToLowerInvariant() with
        | "n" -> Facing.North
        | "e" -> Facing.East
        | "s" -> Facing.South
        | "w" -> Facing.West
        | _ -> raise(System.ArgumentException("Wrong facing input"))

    let ExecuteCommand robot arena command =
        let (x, y, facing) = robot
        let (arenaX, arenaY) = arena

        let validateAndProcessMove x y facing =
            match (x, y) with
            | (x, y) when x <= arenaX && x >= 0 && y <= arenaY && y >= 0 -> (x, y, facing)
            | _ -> raise(System.ArgumentException("Wrong move"))
        
        try
            match Char.ToLowerInvariant(command) with
            | 'r' -> (x, y, enum<Facing>((int facing + 1) % 4))
            | 'l' -> int facing - 1 |> fun f -> 
                match f with
                | -1 -> (x, y, Facing.West)
                | _ ->  (x, y, enum<Facing>(f % 4))
            | 'm' -> facing |> fun f ->
                match f with
                | Facing.North -> validateAndProcessMove x (y + 1) facing
                | Facing.East -> validateAndProcessMove (x + 1) y facing
                | Facing.South -> validateAndProcessMove x (y - 1) facing
                | Facing.West -> validateAndProcessMove (x - 1) y facing
                | _ -> raise(System.ArgumentException("Wrong facing parameter"))
            | _ -> raise(System.ArgumentException("R, L or M was expected"))
        with
            | :? System.ArgumentException as ex -> printfn "\n%s - Retry\n" ex.Message; robot