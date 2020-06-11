namespace FSharpCommandPattern.Domain

module CommandHandler =
    open System
    open System.Linq
    open System.Reflection
    open Command

    type ICommandHandler<'TCommand when 'TCommand :> ICommand> =
        abstract Handle : 'TCommand -> unit

    let handle' (command : 'TCommand when 'TCommand :> ICommand) =
        let handlerTypes =
            Assembly.GetAssembly(typedefof<ICommandHandler<_>>).GetTypes()
            |> Array.filter (fun ht -> not ht.IsAbstract && ht.IsAssignableFrom(typedefof<ICommandHandler<_>>))

        let handlerTypesPerCommandTypes =
            Assembly.GetAssembly(typedefof<ICommand>).GetTypes()
            |> Array.filter typedefof<ICommand>.IsAssignableFrom
            |> Array.map (fun ct -> ct, typedefof<ICommandHandler<_>>.MakeGenericType(ct))
            |> Array.map (fun (ct, hti) ->
                   ct,
                   handlerTypes
                   |> Seq.filter hti.IsAssignableFrom
                   |> Seq.exactlyOne)
            |> fun x -> x.ToDictionary(fst, snd)

        // let getHandler<'TCommand when 'TCommand :> ICommand>() : ICommandHandler<'TCommand> =
        let getHandler() : ICommandHandler<'TCommand> =
            Activator.CreateInstance(handlerTypesPerCommandTypes.[typedefof<'TCommand>]) :?> ICommandHandler<'TCommand>
        let handler = getHandler()
        handler.Handle(command)

    let handle (command : ICommand) =
        let methodInfo = typedefof<ICommandHandler<_>>.DeclaringType.GetMethod("handle'")
        methodInfo.MakeGenericMethod(command.GetType()).Invoke(null, [| command |])
