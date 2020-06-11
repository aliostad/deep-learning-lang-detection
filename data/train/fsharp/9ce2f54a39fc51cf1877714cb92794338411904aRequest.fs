namespace CollectionSample

// Note that this program is defined in a PCL, and is completely platform neutral.
// It will work unchanged on WPF, Xamarin Forms, etc

// This is definitely on the "complicated" side, but shows how to use multiple 
// mailbox processors, defined outside of the main UI, to manage a model
// defined itself as a collection

open System
open Gjallarhorn
open Gjallarhorn.Bindable

type RequestStatus =
    | Unknown
    | Accepted
    | Rejected

and Request = 
        { 
            Id : Guid // What is our unique identifier
            Created : DateTime 
            ExpectedHours : float 
            Status : RequestStatus 
            StatusUpdated : DateTime option 
        }    

module Request =

    // Our messages. This is only used by the component in the application code,
    // but needs to remain public for our ViewModel/Commanding and design time xaml code
    type RequestMsg =
    | Accept
    | Reject

    let create guid hours = { Id = guid ; Created = DateTime.UtcNow ; ExpectedHours = hours ; Status = Unknown ; StatusUpdated = None }

    // We start with a "ViewModel" for cleaner bindings and XAML support
    type RequestViewModel =
        {
            // The properties we want to display
            Id : Guid
            Hours : float
            Status : RequestStatus
            // Our commands
            Accept : VmCmd<RequestMsg>
            Reject : VmCmd<RequestMsg>
            // Bind ourself, which allows the collection parent to use SelectedItem.Self to get the model from XAML
            Self : ISignal<Request>
        }
    let designSignal = create (Guid.NewGuid()) 0.0 |> Signal.constant
    let reqd = { Id = Guid.NewGuid() ; Hours = 45.32 ; Status = Accepted ; Accept = Vm.cmd Accept ; Reject = Vm.cmd Reject ; Self = designSignal }
    
    // Create a component for a single request
    let requestComponent =
        // This is a self-updating component, so we can define our update function locally if we choose
        let update msg model =
            match msg with
            | Accept -> { model with Status = Accepted ; StatusUpdated = Some(DateTime.UtcNow) }
            | Reject -> { model with Status = Rejected ; StatusUpdated = Some(DateTime.UtcNow) }

        // This component works on a model in, and produces a message of updated models out
        Component.create<Request,unit,_> [
            <@ reqd.Id @>       |> Bind.oneWay (fun r -> r.Id)
            <@ reqd.Hours @>    |> Bind.oneWay (fun r -> r.ExpectedHours)
            <@ reqd.Status @>   |> Bind.oneWay (fun r -> r.Status)
            <@ reqd.Accept @>   |> Bind.cmd 
            <@ reqd.Reject @>   |> Bind.cmd 
            <@ reqd.Self @>     |> Bind.self // We bind ourself as a signal, for use with navigation
        ] |> Component.toSelfUpdating update  
