module ForonoiProcessor
open ForonoiMath
open ForonoiSweep
open ForonoiBeach

open Microsoft.FSharp.Control

type Agent<'Type> = Control.MailboxProcessor<'Type>
type Polygon = Coord list
type Polygons = Map<Coord, Polygon>


let processForonoi (coords:(int*int) list) = 
    let sweep = 
        coords 
        |> List.fold (fun acc coord ->
            acc |> insert (Vertex(coord))) startNode

    let beachLine = BeachLine(400,400)
    let removed = Set.empty<CircleCoord>

    let rec processEvent removed (polygons:Polygons) sweep =
        let event, sweep' = pop sweep
        match event with
        | Start -> 
            processEvent removed polygons sweep
        | Vertex(coord) -> 
            match beachLine.insert coord with
            | { removed=removed'; inserted=inserted } -> 
                let removed'' = 
                    removed' |> List.fold (fun set item ->
                        set |> Set.add item) removed
                let sweep''' =
                    inserted 
                    |> List.fold (fun sweep'' i ->
                        sweep |> insert (Circle(i))) sweep'
                processEvent removed'' polygons sweep'''
        | Circle(circleCoord) -> 
            if removed |> Set.contains circleCoord then 
                let removed' = removed |> Set.remove circleCoord
                processEvent removed' polygons sweep'
            else
                // TODO: Add items to polygons

                (* What is the most optimal and/or functional way to
                   associate circle focii with voronoi vertices?  
                   
                   Option 1) 
                    Pass three points around with every circle
                    Loop up polygons by point
                    Add item to Polygons
                   Option 2)
                    Using the circle focus and radius find points on the line. 
                    Problems: Computing to associate; Rounding errors

                   *)
                let polygons' = polygons

                // TODO: remove circle from beach
                processEvent removed polygons sweep'
        | Stop(y) -> ()

    ()