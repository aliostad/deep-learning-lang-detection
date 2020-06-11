namespace global

open System
open System.Collections.ObjectModel


//Listing 4 Sample model
type PositionState = Zero | Opened | Closed

//type Player = {Navn:string; Rating:int}

//type Data() = 
//    static let data () =
//        let list = ObservableCollection<SpillerInfo>()
//        list.Add({Navn="Diamond"; Rating= Some 1346; Gruppe="B" })
//        list.Add({Navn="BamBam"; Rating= Some 1994; Gruppe = "B"})
//        list
//    static member GetData() = data()

[<AbstractClass>]
type MainModel() =
    inherit Model() 
    
    abstract NavneListe: ObservableCollection<SpillerInfo> with get, set
    abstract SelectedPlayer: SpillerInfo with get, set
    abstract AddedPlayer: SpillerInfo with get, set
    abstract AllPlayers: ObservableCollection<SpillerInfo> with get, set

[<AbstractClass>]
type ManagePlayersModel() =
    inherit Model() 
    
    abstract AllPlayers: ObservableCollection<SpillerInfo> with get, set
    abstract CurrentList: ObservableCollection<SpillerInfo> with get, set
    abstract SelectedPlayer: SpillerInfo with get, set
    abstract AddedPlayer: SpillerInfo with get, set


