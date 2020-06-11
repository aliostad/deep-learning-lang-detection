// module GameLogic
module RecSystem
    

type MushroomColor =
| Red
| Green
| Yellow

type PowerUp =
| FireFlower
| Mushroom of MushroomColor
| Star of int

let PowerUpHandler powerup =
    match powerup with
    | FireFlower -> printfn "Ouch Hot!@"
    | Mushroom color -> match color with
                        | Red -> printfn "This is a Red Mushroom"
                        | Green -> printfn "Must be a Paprika"
                        | Yellow -> printfn "Eat it and Space"
    | Star time -> printfn "I feel really gay for %d hours" time


let pp = Star 7
PowerUpHandler pp

let pytha x y = x * y
