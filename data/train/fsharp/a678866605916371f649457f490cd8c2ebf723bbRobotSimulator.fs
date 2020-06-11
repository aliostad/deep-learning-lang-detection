module RobotSimulator

type Bearing = North | East | South | West

type Coordinate = int * int

type Robot = {
    Bearing : Bearing; 
    Position : Coordinate
    }

let createRobot bearing coordinate =
    { Bearing = bearing; Position = coordinate }

let turnRight robot = 
    { robot with Bearing = match robot.Bearing with
    | North -> East
    | East  -> South
    | South -> West
    | West  -> North }

let turnLeft robot =
    { robot with Bearing = match robot.Bearing with
    | North -> West
    | West  -> South
    | South -> East
    | East  -> North }

let advance ({ Bearing = bearing; Position = (x,y) } as robot) =
    { robot with Position = match bearing with
    | North -> (x  ,y+1)
    | East  -> (x+1,y  )
    | South -> (x  ,y-1)
    | West  -> (x-1,y  )
    }

let rec private processCommands robot =
    function
    | [] -> robot
    | 'R' :: commands -> processCommands (turnRight robot) commands
    | 'L' :: commands -> processCommands (turnLeft  robot) commands
    | 'A' :: commands -> processCommands (advance   robot) commands
    | _ :: _ -> failwith "Malfunction, need valid input"

let simulate robot str =
    str
    |> List.ofSeq
    |> processCommands robot
