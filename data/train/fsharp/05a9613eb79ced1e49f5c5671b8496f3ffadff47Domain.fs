module Domain

type EventClass = EventClass of name: string
type ReadModel = ReadModel of name: string

type NhibQuery = NhibQuery of name: string * path: string
type StoredProcedure = StoredProcedure of name: string * path: string
type InfraClass = InfraClass of name: string * path: string
type DomainClass = DomainClass of name: string * path: string
type EventHandlerClass = EventHandlerClass of name: string * path: string * events: EventClass list
type WebClass = WebClass of name: string * path: string

type Q private () =
    static member name (EventClass name') = name' 
    static member name (ReadModel name') = name'
    static member name (NhibQuery (name', _)) = name'
    static member name (StoredProcedure (name', _)) = name'
    static member name (InfraClass (name', _)) = name'
    static member name (DomainClass (name', _)) = name'
    static member name (EventHandlerClass (name', _, _)) = name'
    static member name (WebClass (name', _)) = name'
    static member path (NhibQuery (_, path')) = path'
    static member path (StoredProcedure (_, path')) = path'
    static member path (InfraClass (_, path')) = path'
    static member path (DomainClass (_, path')) = path'
    static member path (EventHandlerClass (_, path', _)) = path'
    static member path (WebClass (_, path')) = path'
    static member events (EventHandlerClass (_, _, events')) = events'

type LocInfo = { hostLoc : string; targetLocs : string list }
type UseInfo<'S, 'T> = { target: 'S; host: 'T; locs: LocInfo list } 
type EpubInfo<'S> = { event: EventClass; host: 'S; locs: LocInfo list  }
type EhandleInfo<'T> = { handler: EventHandlerClass; publisher: 'T; locs: LocInfo list }

type EventPublish = 
    | EpubInIc of EpubInfo<InfraClass>
    | EpubInDc of EpubInfo<DomainClass>
    | EpubInWc of EpubInfo<WebClass>

type Usage =
    // Direct usage
    | RmUsedInSp of UseInfo<ReadModel, StoredProcedure>
    | RmUsedInIc of UseInfo<ReadModel, InfraClass>
    | RmUsedInNq of UseInfo<ReadModel, NhibQuery>
    | SpUsedInSp of UseInfo<StoredProcedure, StoredProcedure>
    | SpUsedInIc of UseInfo<StoredProcedure, InfraClass>
    | SpUsedInDc of UseInfo<StoredProcedure, DomainClass>
    | IcUsedInIc of UseInfo<InfraClass, InfraClass>
    | IcUsedInDc of UseInfo<InfraClass, DomainClass>
    | NqUsedInDc of UseInfo<NhibQuery, DomainClass>
    | NqUsedInIc of UseInfo<NhibQuery, InfraClass>
    | DcUsedInWc of UseInfo<DomainClass, WebClass>
    | DcUsedInDc of UseInfo<DomainClass, DomainClass>
    | DcUsedInIc of UseInfo<DomainClass, InfraClass>
    | IcUsedInWc of UseInfo<InfraClass, WebClass>
    | WcUsedInWc of UseInfo<WebClass, WebClass>
    | RmUsedInEh of UseInfo<ReadModel, EventHandlerClass>
    | NqUsedInEh of UseInfo<NhibQuery, EventHandlerClass>
    | SpUsedInEh of UseInfo<StoredProcedure, EventHandlerClass>
    | IcUsedInEh of UseInfo<InfraClass, EventHandlerClass>
    | DcUsedInEh of UseInfo<DomainClass, EventHandlerClass>
    | WcUsedInEh of UseInfo<WebClass, EventHandlerClass>
   
    // Event handling usage
    | EhcHandlesIc of EhandleInfo<InfraClass>
    | EhcHandlesDc of EhandleInfo<DomainClass>
    | EhcHandlesWc of EhandleInfo<WebClass>
    | EhcHandlesEhc of EhandleInfo<EventHandlerClass>

type UsageChain = Usage list

let startingUsageOfRm (rm: ReadModel) (usageCollection : Usage list) =
    let filter =
        function 
        | RmUsedInSp { target = target } -> target = rm
        | RmUsedInIc { target = target } -> target = rm
        | RmUsedInNq { target = target } -> target = rm
        | RmUsedInEh { target = target } -> target = rm
        | _ -> false
    usageCollection |> List.where filter

let traceNextUsage (usage : Usage) =
    let nextUsageUseAvailableLocs locsNext locs =
        let availables = locs |> List.map (fun loc -> loc.hostLoc ) 
        locsNext 
        |> List.collect (fun loc -> loc.targetLocs)
        |> List.exists (fun x -> List.contains x availables)          
    match usage with
    | RmUsedInSp { target = target; host = host; locs = locs } ->
        (function
            | SpUsedInSp { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | SpUsedInIc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | SpUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | SpUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | _ -> None)
    | RmUsedInIc { target = target; host = host; locs = locs } ->
        (function
            | IcUsedInIc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | _ -> None)
    | RmUsedInNq { target = target; host = host; locs = locs } ->
        (function
            | NqUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | NqUsedInIc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | NqUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it       
            | _ -> None)
    | SpUsedInSp { target = target; host = host; locs = locs } ->
        (function
            | SpUsedInSp { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | SpUsedInIc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | SpUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | SpUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | _ -> None)
    | SpUsedInIc { target = target; host = host; locs = locs } ->
         (function
            | IcUsedInIc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | _ -> None)
    | SpUsedInDc { target = target; host = host; locs = locs } ->
         (function
            | DcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | DcUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | DcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | _ -> None)
    | IcUsedInIc { target = target; host = host; locs = locs } ->
         (function
            | IcUsedInIc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | _ -> None)
    | IcUsedInDc { target = target; host = host; locs = locs } ->
         (function
            | DcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | DcUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | DcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | _ -> None)
    | NqUsedInDc { target = target; host = host; locs = locs } ->
         (function
            | DcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | DcUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | DcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | _ -> None)
    | NqUsedInIc { target = target; host = host; locs = locs } ->
         (function
            | IcUsedInIc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | _ -> None)
    | DcUsedInWc { target = target; host = host; locs = locs } ->
         (function
            | WcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | WcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | _ -> None)
    | DcUsedInDc { target = target; host = host; locs = locs } ->
         (function
            | DcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | DcUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | DcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | _ -> None)
    | DcUsedInIc { target = target; host = host; locs = locs } ->
         (function
            | IcUsedInIc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInDc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | _ -> None)
    | IcUsedInWc { target = target; host = host; locs = locs } ->
         (function
            | WcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | WcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | _ -> None)
    | WcUsedInWc { target = target; host = host; locs = locs } ->
         (function
            | WcUsedInWc { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | WcUsedInEh { target = target'; host = host'; locs = locs' } as it when host = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | _ -> None)
    | RmUsedInEh { target = target; host = host; locs = locs } ->
         (function
            | EhcHandlesIc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesDc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesWc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesEhc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it     
            | _ -> None)                                                                                                                               
    | NqUsedInEh { target = target; host = host; locs = locs } ->                                                                                      
         (function                                                                                                                                     
            | EhcHandlesIc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesDc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesWc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesEhc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it    
            | _ -> None)                                                                                                                               
    | SpUsedInEh { target = target; host = host; locs = locs } ->                                                                                      
         (function                                                                                                                                     
            | EhcHandlesIc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesDc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesWc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesEhc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it  
            | _ -> None)                                                                                                                                      
    | IcUsedInEh { target = target; host = host; locs = locs } ->                                                                                      
         (function                                                                                                                                     
            | EhcHandlesIc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesDc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesWc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesEhc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it  
            | _ -> None)                                                                                                                               
    | DcUsedInEh { target = target; host = host; locs = locs } ->                                                                                      
         (function                                                                                                                                     
            | EhcHandlesIc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesDc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesWc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesEhc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | _ -> None)
    | WcUsedInEh { target = target; host = host; locs = locs } -> 
        (function                                                                                                                                     
            | EhcHandlesIc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesDc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesWc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesEhc { handler = handler'; publisher = publisher'; locs = locs' } as it when host = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | _ -> None)
    | EhcHandlesIc { handler = handler; publisher = publisher; locs = locs } ->
         (function
            | IcUsedInIc { target = target'; host = host'; locs = locs' } as it when publisher = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInDc { target = target'; host = host'; locs = locs' } as it when publisher = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInWc { target = target'; host = host'; locs = locs' } as it when publisher = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | IcUsedInEh { target = target'; host = host'; locs = locs' } as it when publisher = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | _ -> None)                                                                                                                         
    | EhcHandlesDc { handler = handler; publisher = publisher; locs = locs } ->                                                                 
         (function                                                                                                                               
            | DcUsedInWc { target = target'; host = host'; locs = locs' } as it when publisher = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | DcUsedInDc { target = target'; host = host'; locs = locs' } as it when publisher = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | DcUsedInEh { target = target'; host = host'; locs = locs' } as it when publisher = target' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | _ -> None)
    | EhcHandlesWc { handler = handler; publisher = publisher; locs = locs } ->
         (function
            | WcUsedInWc { target = target'; host = host'; locs = locs' } as it when publisher = target' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | WcUsedInEh { target = target'; host = host'; locs = locs' } as it when publisher = target' && nextUsageUseAvailableLocs locs' locs -> Some it
            | _ -> None)
    | EhcHandlesEhc { handler = handler; publisher = publisher; locs = locs } ->
        (function                                                                                                                                     
            | EhcHandlesIc { handler = handler'; publisher = publisher'; locs = locs' } as it when publisher = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesDc { handler = handler'; publisher = publisher'; locs = locs' } as it when publisher = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesWc { handler = handler'; publisher = publisher'; locs = locs' } as it when publisher = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | EhcHandlesEhc { handler = handler'; publisher = publisher'; locs = locs' } as it when publisher = handler' && nextUsageUseAvailableLocs locs' locs -> Some it           
            | _ -> None) 

let traceUsageChain (startingUsage : Usage) (usageCollection : Usage list) : UsageChain list =
    let growOneStep (revChains : UsageChain list) =
        let mutable stagnated = true
        let aftergrow = 
            revChains
            |> List.collect (fun revChain ->
                let filter = List.head revChain |> traceNextUsage
                let nexts = usageCollection |> List.choose filter 
                match nexts with
                | [] -> [ revChain ]
                | _ ->
                    stagnated <- false 
                    nexts |> List.map (fun e -> e :: revChain))        
        (stagnated, aftergrow)
    let rec loop stagnated revChains =       
        if (stagnated) 
        then revChains
        else 
            let stagnated', aftergrow = growOneStep revChains
            loop stagnated' aftergrow
    loop false [[startingUsage]]
    |> List.map (fun revChain -> List.rev revChain)
     
// https://github.com/tpetricek/Documents/blob/master/Talks%202011/Data%20Access%20(GOTO%20Copenhagen)/GotoDemos/XmlStructural/FSharpWeb.Core/StructuralXml.fs#L68  

