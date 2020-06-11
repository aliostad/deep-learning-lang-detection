namespace FsIntegrator

open System
open FsIntegrator.Routing.Types


type DefinitionType =
    | ProcessStep of (FsIntegrator.Message -> FsIntegrator.Message)
    | Consume     of IConsumer * (Message -> Message)
    | Choose      of ConditionalRoute list
    | ErrorHandlers of ErrorHandlerRoute list
and
    [<Sealed>]
    Route
and Route
    with
        static member internal Create : IProducer -> DefinitionType list -> Route
        member          Id          : Guid with  get
        member internal Producer    : IProducer with get
        member internal SetProducer : IProducer -> Route
        member internal Route       : DefinitionType list with get
        member internal SetRoute    : DefinitionType list -> Route
        member internal Register    : IEngineServices -> unit

and
    [<AbstractClassAttribute ()>]
    Intermediate =
    class
        new : unit -> Intermediate
        abstract member internal DefinitionType : DefinitionType with get
    end
and
    ConditionalRoute
and
    ConditionalRoute with
        static member   Create : DefinitionType list  -> BooleanMacro -> ConditionalRoute
        member          Id : Guid with get
        member internal Route : DefinitionType list with get
        member internal SetRoute : DefinitionType list -> ConditionalRoute
        member internal Register : IEngineServices -> unit
        member internal Evaluate : Message -> bool
and
    ErrorHandlerType = 
        | Divert    //  send the message to a different route, afterwards it is no more considered as error
        | Equip     //  equip the error with some logic, before termination
and
    ErrorHandlerRoute
and
    ErrorHandlerRoute with
        static member   Create : DefinitionType list -> ErrorHandlerType -> Type list -> ErrorHandlerRoute
        member          Id : Guid with get
        member internal ErrorHandlerType : ErrorHandlerType with get
        member internal HandledTypes : Type list with get
        member internal Route :  DefinitionType list with get
        member internal SetRoute : DefinitionType list  -> ErrorHandlerRoute

        member internal Register : IEngineServices -> unit
        member          CanHandle : 'a -> bool


