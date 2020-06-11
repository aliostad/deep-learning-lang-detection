module Spyfall

type Player = 
    { Name : string }
    
type Role = 
    | Spy of Player
    | Normal of Player * Name : string
    
type Location = 
    { Name : string
      Roles : string list }
    
type RoleOutcome = 
    | Win
    | Lose
    
type SetupState = 
    { Players : Player list
      Location : Location }
    
type GameState = 
    | Valid of Role list * Spy : Player
    | Invalid
    
type FinishedState = 
    { Outcome : Role * RoleOutcome }
   
let addPlayer player state = 
    { state with Players = player::state.Players }
    
let pickSpy state = 
    let rng = System.Random()
    let spyIndex = rng.Next(state.Players.Length)
    state.Players.[spyIndex]
    
let shuffleRoles roles = 
    let swap (a : _ []) x y = 
        let tmp = a.[x]
        a.[x] <- a.[y]
        a.[y] <- tmp
        
    let rng = new System.Random()
    let shuffle a = Array.iteri (fun i _ -> swap a i (rng.Next(i, a.Length))) a
    let rolesCopy = roles |> Array.copy
    shuffle rolesCopy
    rolesCopy
    
let start state = 
    if state.Players = List.empty then 
        Invalid
    else
        let spy = state |> pickSpy
        
        let shuffled = 
            state.Location.Roles
            |> Array.ofList
            |> shuffleRoles
        
        let others = 
            state.Players
            |> List.except (List.singleton spy)
            |> List.mapi (fun i j -> Role.Normal(j, shuffled.[i]))
        
        Valid(Role.Spy(spy) :: others, spy)