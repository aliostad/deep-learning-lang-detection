namespace BucklingSprings.Aware.Input

open System.Windows.Input

type CommandBase<'a>(cmd : 'a -> Unit) =
    let canExecuteChanged = Event<System.EventHandler, System.EventArgs>()
    interface ICommand with
        member this.Execute p = cmd (p :?> 'a)
        member this.CanExecute _ = true
        member this.add_CanExecuteChanged handler = canExecuteChanged.Publish.AddHandler(handler)
        member this.remove_CanExecuteChanged handler = canExecuteChanged.Publish.RemoveHandler(handler)

type AlwaysExecutableCommand(cmd : Unit -> Unit) =
    inherit CommandBase<obj>(fun _ -> cmd())

type DelegatingCommand(c : Unit -> Unit) as dc =
    let mutable cmd = c
    let mutable canExecute = false
    let mutable executing = false
    let canExecuteChanged = Event<System.EventHandler, System.EventArgs>()
    member x.DelegateTo (c : Unit -> Unit) =
        cmd <- c
    member x.ChangeCanExecuteTo b =
        canExecute <- b
        canExecuteChanged.Trigger(dc, System.EventArgs.Empty)
    interface ICommand with
        member this.Execute p =
            executing <- true
            canExecuteChanged.Trigger(dc, System.EventArgs.Empty)
            cmd ()
            executing <- false
            canExecuteChanged.Trigger(dc, System.EventArgs.Empty)
        member this.CanExecute _ = canExecute && (not(executing))
        member this.add_CanExecuteChanged handler = canExecuteChanged.Publish.AddHandler(handler)
        member this.remove_CanExecuteChanged handler = canExecuteChanged.Publish.RemoveHandler(handler)

