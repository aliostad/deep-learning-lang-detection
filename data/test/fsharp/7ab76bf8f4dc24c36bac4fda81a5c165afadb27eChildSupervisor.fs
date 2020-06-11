namespace Wj.Async

open System.Threading

module internal ChildSupervisor =
  [<ReferenceEquality>]
  type T =
    { name : string;
      mutable dispatcher : IDispatcher;
      mutable parent : ISupervisor option;
      mutable handlers : exn SupervisedCallback list; }

    interface ISupervisor with
      member t.Dispatcher = t.dispatcher

      member t.Parent = t.parent

      member t.Name = t.name

      member t.SendException(ex) =
        let processException ex =
          for (supervisor, handler) in t.handlers do
            try
              supervisor.Run(fun () -> handler ex)
            with ex ->
              supervisor.SendException(ex)
          match t.parent with
          | Some parent ->
            let ex' =
              match ex with
              | SupervisorChildException (supervisorNames, _) ->
                SupervisorChildException (t.name :: supervisorNames, ex)
              | ex ->
                SupervisorChildException ([t.name], ex)
            parent.SendException(ex')
          | None -> ()
        if obj.ReferenceEquals(ThreadShared.currentDispatcher(), t.dispatcher) then
          processException ex
        else
          t.dispatcher.Enqueue((t.dispatcher.RootSupervisor, fun () -> processException ex))

      member t.Detach() = t.parent <- None

      member t.UponException(handler) =
        (t :> ISupervisor).UponException((ThreadShared.currentSupervisor (), handler))

      member t.UponException(supervisedHandler) =
        let rec loop () =
          let baseValue = t.handlers
          let newValue = supervisedHandler :: t.handlers
          let currentValue = Interlocked.CompareExchange(&t.handlers, newValue, baseValue)
          if not (obj.ReferenceEquals(currentValue, baseValue)) then
            loop ()
        loop ()

      member t.Run(f) =
        ThreadShared.pushSupervisor t
        try
          f ()
        finally
          ThreadShared.popSupervisor t

  let inline create name =
    { name = name;
      dispatcher = ThreadShared.currentDispatcher ();
      parent = ThreadShared.tryCurrentSupervisor ();
      handlers = []; }
    :> ISupervisor
