// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.

module fracas

open Microsoft.FSharp.Quotations
open Microsoft.FSharp.Quotations.Patterns
open System
open System.ComponentModel
open System.Threading
open System.Windows.Input

[<AutoOpen>]
module private NotifyBaseImpl =

    let getPropertyName propertyExpr =

        match propertyExpr with
        | PropertyGet(_, propOrValInfo, _) -> propOrValInfo.Name
        | _ -> failwith "Unexpected expression type; needs PropertyGet"


type IFieldBacker =
    abstract member Updated : IEvent<obj> with get

/// Provides an ICommand interface with additional useful properties.
type ICommandWithExtras =
    inherit ICommand
    abstract member IsExecuting : bool with get
    abstract member IsNotExecuting : bool with get

/// Implements INotifyPropertyChanged for use in observable models.
type NotifyBase() =

    let propertyChanged = Event<_, _>()
    
    interface INotifyPropertyChanged with
        [<CLIEvent>]
        member __.PropertyChanged = propertyChanged.Publish

    member internal __.MakeField<'T>(propertyExpr, ?initialValue: 'T) =
        new FieldBacker<'T>(__, propertyExpr, initialValue)

    member internal __.MakeDerivedField<'T>(propertyExpr, precedingFields, generateValue) =
        new DerivedFieldBacker<'T>(__, propertyExpr, precedingFields, generateValue)

    member internal __.MakeCommand<'T>(canExecuteHandler, executeHandler, notifyOnFieldUpdate,
                                       ?_cancellationToken) =
        CommandBacker<'T>(canExecuteHandler, executeHandler, notifyOnFieldUpdate)

    member internal __.MakeAsyncCommand<'TInput, 'TOutput>(canExecuteHandler,
                                                           executeHandler,
                                                           onDone,
                                                           onException,
                                                           onCancelled,
                                                           getCancellationToken,
                                                           notifyOnFieldUpdate) =
        AsyncCommandBacker<'TInput, 'TOutput>(canExecuteHandler, executeHandler,
            onDone, onException, onCancelled, getCancellationToken, notifyOnFieldUpdate)

    // Used by FieldBacker to update listeners
    member internal x.NotifyPropertyChanged(propertyName) =
        propertyChanged.Trigger(x, PropertyChangedEventArgs(propertyName))

// Backs fields that cause updates in ObservableModel.
and FieldBacker<'T>(om: NotifyBase, propertyExpr, initialValue: 'T option) =

    let mutable value = match initialValue with
                        | Some t -> t
                        | None -> Unchecked.defaultof<'T>
    let internalUpdateEvent = new Event<obj>()

    let propertyName = getPropertyName propertyExpr

    let setValue newValue =
        if Object.Equals(value, newValue) then false
        else 
            value <- newValue
            om.NotifyPropertyChanged(propertyName)
            internalUpdateEvent.Trigger newValue
            true

    member __.Value
        with get() = value
        and set newValue = setValue newValue |> ignore

    /// Sets the value; use when a return value is required to determine if the value has changed.
    member __.Set newValue = setValue newValue

    interface IFieldBacker with
        member __.Updated: IEvent<obj> = 
            internalUpdateEvent.Publish

    member internal x.Updated = (x :> IFieldBacker).Updated

/// Derives its value from other fields.
and DerivedFieldBacker<'T>(om: NotifyBase, propertyExpr, precedingFields, generateValue) =

    let internalUpdateEvent = new Event<obj>()

    let propertyName = getPropertyName propertyExpr

    do
        let onPrecedingChanged _ = om.NotifyPropertyChanged(propertyName)
                                   internalUpdateEvent.Trigger(generateValue())

        for preceding : IFieldBacker in precedingFields do
            preceding.Updated.Add(onPrecedingChanged)

    member __.Value
        with get() : 'T = generateValue()

    interface IFieldBacker with
        member __.Updated: IEvent<obj> = 
            internalUpdateEvent.Publish

    member internal x.Updated = (x :> IFieldBacker).Updated

/// Backs commands; note that the handlers take 'T option so use your pattern matching.
and CommandBacker<'T>(canExecuteHandler: 'T option -> bool,
                      executeHandler: 'T option -> unit,
                      notifyOnFieldUpdate: IFieldBacker list) as self =
    inherit NotifyBase()

    let canExecuteChanged = Event<_, _>()
    let mutable isExecuting = false

    do
        let notifyUpdate = fun _ -> self.NotifyCanExecuteChanged()
        for backer in notifyOnFieldUpdate do
            backer.Updated.Add(notifyUpdate)

    let objParameterToTypedParameter (parameter : obj) =

        match Convert.ChangeType(parameter, typedefof<'T>) with
        | null -> None
        | v -> Some (v :?> 'T)

    interface ICommandWithExtras with
        [<CLIEvent>]
        member __.CanExecuteChanged = canExecuteChanged.Publish

        member __.CanExecute parameter =

            not isExecuting && canExecuteHandler (objParameterToTypedParameter parameter)

        member __.Execute parameter =

            try
                executeHandler (objParameterToTypedParameter parameter)
            finally
                ()

        member __.IsExecuting with get() = isExecuting
        member __.IsNotExecuting with get() = not isExecuting

    member self.ICommand = self :> ICommandWithExtras

    member self.IsExecuting = (self :> ICommandWithExtras).IsExecuting
    member self.IsNotExecuting = (self :> ICommandWithExtras).IsNotExecuting

    member self.NotifyCanExecuteChanged() = canExecuteChanged.Trigger(self, EventArgs.Empty)

/// Backs commands that are executed asynchronously; note that the handlers take 'T option so use your pattern matching.
and AsyncCommandBacker<'TInput, 'TOutput>(canExecuteHandler: 'TInput option -> bool,
                                          executeHandler: 'TInput option -> Async<'TOutput>,
                                          onDone: 'TOutput -> unit,
                                          onException: Exception -> unit,
                                          onCancelled: OperationCanceledException -> unit,
                                          getCancellationToken: unit -> CancellationToken option,
                                          notifyOnFieldUpdate: IFieldBacker list) as self =
    inherit NotifyBase()

    let canExecuteChanged = Event<_, _>()
    let mutable isExecuting = false

    let setIsExecuting value =
        isExecuting <- value
        self.NotifyPropertyChanged("IsExecuting")
        self.NotifyPropertyChanged("IsNotExecuting")

    do
        let notifyUpdate = fun _ -> self.NotifyCanExecuteChanged()
        for backer in notifyOnFieldUpdate do
            backer.Updated.Add(notifyUpdate)

    let objParameterToTypedParameter (parameter : obj) =

        match Convert.ChangeType(parameter, typedefof<'TInput>) with
        | null -> None
        | v -> Some (v :?> 'TInput)

    interface ICommandWithExtras with
        [<CLIEvent>]
        member __.CanExecuteChanged = canExecuteChanged.Publish

        member __.CanExecute parameter =

            not isExecuting && canExecuteHandler (objParameterToTypedParameter parameter)

        member __.Execute parameter =

            let wrappedOnDone value = try
                                          onDone value
                                      finally
                                          setIsExecuting false

            let wrappedOnException exn = try
                                             onException exn
                                         finally
                                             setIsExecuting false

            let wrappedOnCancelled cexn = try
                                              onCancelled cexn
                                          finally
                                              setIsExecuting false

            setIsExecuting true
            try
                Async.StartWithContinuations(
                    executeHandler (objParameterToTypedParameter parameter),
                    wrappedOnDone, wrappedOnException, wrappedOnCancelled,
                    ?cancellationToken = getCancellationToken())
            with
                _ -> setIsExecuting false

        member __.IsExecuting with get() = isExecuting
        member __.IsNotExecuting with get() = not isExecuting

    member self.ICommand = self :> ICommandWithExtras

    member self.IsExecuting = (self :> ICommandWithExtras).IsExecuting
    member self.IsNotExecuting = (self :> ICommandWithExtras).IsNotExecuting

    member self.NotifyCanExecuteChanged() = canExecuteChanged.Trigger(self, EventArgs.Empty)

// Functions

let mkField<'T> propertyExpr
                (initialValue: 'T)
                (obs: NotifyBase) =
                
    obs.MakeField (propertyExpr, initialValue)


let mkDerivedField<'T> propertyExpr
                       precedingFields
                       generateValue
                       (obs: NotifyBase) =

        obs.MakeDerivedField<'T>(propertyExpr, precedingFields, generateValue)


let mkCommand<'T> canExecuteHandler executeHandler (notifyOnFieldUpdate: IFieldBacker list) (obs: NotifyBase) =
    
    obs.MakeCommand<'T> (canExecuteHandler, executeHandler, notifyOnFieldUpdate)


let mkAsyncCommand<'TInput, 'TOutput> canExecuteHandler
                                      executeHandler
                                      onDone
                                      onException
                                      onCancelled
                                      getCancellationToken 
                                      (notifyOnFieldUpdate: IFieldBacker list)
                                      (obs: NotifyBase) =

    obs.MakeAsyncCommand<'TInput, 'TOutput> (canExecuteHandler, executeHandler,
        onDone, onException, onCancelled, getCancellationToken, notifyOnFieldUpdate)


let notifyAllChanged (obs: NotifyBase) = obs.NotifyPropertyChanged ""

let ignoreContinuation<'TInput, 'TOutput> (_in : 'TInput) = Unchecked.defaultof<'TOutput>
