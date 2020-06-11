module Actors

open Akka.Actor
open Akka.FSharp
open Messages
open MessageHandlers
open ActorState

let emptyState = 
    let nobody = ActorRefs.Nobody :> IActorRef

    { container = { name = "void"; ref = nobody }
      output = nobody
      objectsYouHave = Set.empty<NamedObject>
      objectsYouSee = Set.empty<NamedObject>
      exitsYouHave = Set.empty<NamedObject>
      exitsYouSee = Set.empty<NamedObject> }

let thing name (mailbox : Actor<obj>) = 
    let self = 
        { name = name
          ref = mailbox.Self }
    
    let rec loop (state : ThingState) = 
        actor { 
            let! m = mailbox.Receive()
            match m with
            | :? ContaineeMessages as message -> return! containedHandler message self loop state
            | _ -> ()
            return! loop state
        }
    
    loop emptyState


let container name allowEnter allowExit (mailbox : Actor<obj>) = 
    let self = 
        { name = name
          ref = mailbox.Self }
    
    let rec loop (state : ThingState) = 
        actor { 
            let! m = mailbox.Receive()
            match m with
            | :? ContainerMessages as message -> return! containerHandler message self allowEnter allowExit loop state
            | :? ContaineeMessages as message -> return! containedHandler message self loop state
            | _ -> ()
            return! loop state
        }
    
    loop emptyState

let living name (mailbox : Actor<obj>) = 
    let self = 
        { name = name
          ref = mailbox.Self }
    
    let rec loop (state : ThingState) = 
        actor { 
            let! m = mailbox.Receive()
            match m with
            | :? ContainerMessages as message -> return! containerHandler message self false false loop state
            //TODO: replace this and make agents handle special inventory events
            | :? ContaineeMessages as message -> return! containedHandler message self loop state
            | :? NotifyMessages as message -> return! notifyHandler message self loop state
            | :? AgentMessages as message -> return! agentHandler message self loop state
            | _ -> ()
            return! loop state
        }
    
    loop emptyState

let npc name (mailbox : Actor<obj>) = 
    let self = 
        { name = name
          ref = mailbox.Self }
    
    let rec loop (state : ThingState) = 
        actor { 
            let! m = mailbox.Receive()
            match m with
            | :? ContainerMessages as message -> return! containerHandler message self false false loop state
            //TODO: replace this and make agents handle special inventory events
            | :? ContaineeMessages as message -> return! containedHandler message self loop state
            | :? NotifyMessages as message -> return! notifyHandler message self loop state
            | :? AgentMessages as message -> return! agentHandler message self loop state
            | _ -> ()
            return! loop state
        }
    
    loop emptyState

let player name (mailbox : Actor<obj>) = 
    let self = 
        { name = name
          ref = mailbox.Self }
    
    let rec loop (state : ThingState) = 
        actor { 
            let! m = mailbox.Receive()
            match m with
            | :? ContainerMessages as message -> return! containerHandler message self false false loop state
            //TODO: replace this and make agents handle special inventory events
            | :? ContaineeMessages as message -> return! containedHandler message self loop state
            | :? NotifyMessages as message -> return! notifyHandler message self loop state
            | :? AgentMessages as message -> return! agentHandler message self loop state
            | _ -> ()
            return! loop state
        }
    
    loop emptyState