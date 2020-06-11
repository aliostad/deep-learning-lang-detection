namespace FsIntegrator

open System
open FsIntegrator
open FsIntegrator.Routing.Types


type DefinitionType =
    | ProcessStep   of (Message -> Message)
    | Consume       of IConsumer * (Message -> Message)
    | Choose        of ConditionalRoute list
    | ErrorHandlers of ErrorHandlerRoute list
and Route = {
        Id'       : Guid
        Producer' : IProducer
        Route'    : DefinitionType list
    }
    with
        static member   Create p r = {Id' = Guid.NewGuid(); Producer' = p ; Route' = r}
        member          this.Id with get() = this.Id'
        member internal this.Producer with  get() = this.Producer'
        member internal this.SetProducer p = { this with Producer' = p}
        member internal this.Route with get() = this.Route'
        member internal this.SetRoute newRoute = {this with Route' = newRoute }

        member internal this.Register services =
            let reg data =
                match box(data) with
                | :? IRegisterEngine as re -> re.Register services
                | _ -> ()
            reg this.Producer'
            this.Route' |> List.iter(fun routeElm ->
                match routeElm with
                | Consume(consumerComponent, hook) -> reg consumerComponent
                | _ -> ())

and
    [<AbstractClass>]
    Intermediate() =
        abstract member DefinitionType : DefinitionType with get
and
    ConditionalRoute = {
        Id'        : Guid
        Route'     : DefinitionType list
        Condition' : BooleanMacro
    }
    with
        static member Create r c = {Id' = Guid.NewGuid(); Route' = r; Condition' = c}
        member          this.Id with get() = this.Id'
        member internal this.Route with get() = this.Route'
        member internal this.SetRoute newRoute = {this with Route' = newRoute } 

        member internal this.Register services =
            let reg data =
                match box(data) with
                | :? IRegisterEngine as re -> re.Register services
                | _ -> ()
            this.Route' |> List.iter(fun routeElm ->
                match routeElm with
                | Consume(consumerComponent, hook) -> reg consumerComponent
                | _ -> ())

        member internal this.Evaluate (message:Message) =
            this.Condition'.Evaluate message
and
    ErrorHandlerType = 
        | Divert    //  send the message to a different route, afterwards it is no more considered as error
        | Equip     //  equip the error with some logic, before termination
and
    ErrorHandlerRoute = {
        Id'                : Guid
        ErrorHandlerType'  : ErrorHandlerType
        HandledTypes'      : Type list
        Route'             : DefinitionType list  
    }
    with
        static member Create r et tl = {Id' = Guid.NewGuid(); Route' = r; ErrorHandlerType' = et; HandledTypes' = tl}
        member          this.Id with get() = this.Id'
        member internal this.ErrorHandlerType with get() = this.ErrorHandlerType'
        member internal this.HandledTypes with get() = this.HandledTypes'
        member internal this.Route with get() = this.Route'
        member internal this.SetRoute newRoute = {this with Route' = newRoute } 

        member internal this.Register services =
            let reg data =
                match box(data) with
                | :? IRegisterEngine as re -> re.Register services
                | _ -> ()
            this.Route' |> List.iter(fun routeElm ->
                match routeElm with
                | Consume(consumerComponent, hook) -> reg consumerComponent
                | _ -> ())

        member          this.CanHandle (errorInstance) =
            this.HandledTypes' |> List.tryFind(fun t -> t.IsInstanceOfType(errorInstance)) <> None
