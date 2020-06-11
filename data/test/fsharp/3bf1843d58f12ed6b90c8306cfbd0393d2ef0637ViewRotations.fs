namespace RubicsCube.Core

module ViewRotations = 

    open Utils

    let rotateViewRight (cube: Cube): Cube = 
        let last = List.last cube
        let subcube = cube.[1..4]

        match subcube with 
        | x::xs -> 
            [rotateFaceRight (Array2D.copy cube.Head)] @ 
            xs @ 
            [x] @ 
            [rotateFaceLeft (Array2D.copy last)]
        | [] -> []

    let rotateViewLeft (cube: Cube): Cube = 
        let last = List.last cube
        let subcube = cube.[1..4]
        let lastS = List.last subcube
    
        [rotateFaceLeft (Array2D.copy cube.Head)] @ 
        [lastS] @ 
        subcube.[0..2] @ 
        [rotateFaceRight (Array2D.copy last)]

    let V = Turn.create "V" rotateViewRight rotateViewLeft
