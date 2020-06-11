module ViewModels.MainViewModel

open Enums
open Models
open System.Windows.Input
open ViewModels.BaseViewModel

type MainViewModel() as mainVM = 
    inherit BaseViewModel()
    let mutable _value : int = 0
    let mutable _areCoinsGivenBack : bool = false
    let mutable _state : ParkingMeterState = ParkingMeterState.Q0
    let mutable _visitedSates : List<ParkingMeterState> = [ ParkingMeterState.Q0 ]
    let _stateTransitionArray = [|   
        [| 0; int ParkingMeterState.Q0; int ParkingMeterState.Q1; int ParkingMeterState.Q2; int ParkingMeterState.Q3; int ParkingMeterState.Q4; int ParkingMeterState.Q5; int ParkingMeterState.Q6; int ParkingMeterState.Q7|]  
        [| 1; int ParkingMeterState.Q1; int ParkingMeterState.Q2; int ParkingMeterState.Q3; int ParkingMeterState.Q4; int ParkingMeterState.Q5; int ParkingMeterState.Q6; int ParkingMeterState.Q7; int ParkingMeterState.Q0|] 
        [| 2; int ParkingMeterState.Q2; int ParkingMeterState.Q3; int ParkingMeterState.Q4; int ParkingMeterState.Q5; int ParkingMeterState.Q6; int ParkingMeterState.Q7; int ParkingMeterState.Q0; int ParkingMeterState.Q0|]
        [| 5; int ParkingMeterState.Q5; int ParkingMeterState.Q6; int ParkingMeterState.Q7; int ParkingMeterState.Q0; int ParkingMeterState.Q0; int ParkingMeterState.Q0; int ParkingMeterState.Q0; int ParkingMeterState.Q0|] 
    |]
    
    let createCommand action canExecute = 
        let event1 = Event<_, _>()
        { new ICommand with
              member this.CanExecute(obj) = canExecute (obj)
              member this.Execute(obj) = action (obj)
              member this.add_CanExecuteChanged (handler) = event1.Publish.AddHandler(handler)
              member this.remove_CanExecuteChanged (handler) = event1.Publish.AddHandler(handler) }
    
    let addToList (list : List<ParkingMeterState>) (element : ParkingMeterState) = element :: list
    
    member this.Value 
        with get () = _value
        and set (v : int) = 
            _value <- v
            base.OnPropertyChanged(<@ this.Value @>)
    
    member this.State 
        with get () = _state
        and set (v : ParkingMeterState) = 
            _state <- v
            base.OnPropertyChanged(<@ this.State @>)

    member this.IsTicketGiven 
        with get () = if this.State = ParkingMeterState.Q7 then true else false

    member this.AreCoinsGivenBack 
        with get () = _areCoinsGivenBack
        and set (v : bool) = 
            _areCoinsGivenBack <- v
            base.OnPropertyChanged(<@ this.AreCoinsGivenBack @>)
    
    member this.StateRoad = _visitedSates |> List.fold (fun string s -> " > " + s.ToString() + string) ""
    member this.AddToValue(value : int) = this.Value <- this.Value + value
    
    member this.AddOne = 
        createCommand (fun _ -> 
            this.AddToValue(1)
            this.manageState(1)) (fun _ -> true)
    
    member this.AddTwo = 
        createCommand (fun _ -> 
            this.AddToValue(2)
            this.manageState(2)) (fun _ -> true)
    
    member this.AddFive = 
        createCommand (fun _ -> 
            this.AddToValue(5)
            this.manageState(5)) (fun _ -> true)
    
    member private this.manageState(automataValue : int) = 
        let currentValue = this.Value
        let currentStateValue : int = int this.State
        match automataValue with
        | 1 -> this.changeState (_stateTransitionArray.[1].[currentStateValue + 1])
        | 2 -> this.changeState (_stateTransitionArray.[2].[currentStateValue + 1])
        | 5 -> this.changeState (_stateTransitionArray.[3].[currentStateValue + 1])
        | _ -> this.changeState (int ParkingMeterState.Q0)
    
    member private this.changeState = 
        fun (stateValue : int) ->
            if this.AreCoinsGivenBack = true then this.AreCoinsGivenBack <- false
            match stateValue with
            | 0 -> this.State <- ParkingMeterState.Q0
                   if this.Value > 7 then 
                    this.Value <- 0
                    this.AreCoinsGivenBack <- true
                   else
                    this.Value <- 0
            | 1 -> this.State <- ParkingMeterState.Q1
            | 2 -> this.State <- ParkingMeterState.Q2
            | 3 -> this.State <- ParkingMeterState.Q3
            | 4 -> this.State <- ParkingMeterState.Q4
            | 5 -> this.State <- ParkingMeterState.Q5
            | 6 -> this.State <- ParkingMeterState.Q6
            | 7 -> this.State <- ParkingMeterState.Q7
                   this.Value <- 0
            | _ -> this.State <- ParkingMeterState.Q0
            _visitedSates <- addToList _visitedSates this.State
            mainVM.OnPropertyChanged(<@ this.StateRoad @>)
            mainVM.OnPropertyChanged(<@ this.IsTicketGiven @>)
