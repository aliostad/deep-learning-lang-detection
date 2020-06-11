open System
open System.Net

let wc = new WebClient()

// IEvent.Add
wc.DownloadProgressChanged.Add(
  fun args -> printfn "Percent complete %d" args.ProgressPercentage)

// Event.listen
wc.DownloadStringCompleted
  |> Event.filter(fun args -> args.Error = null && not args.Cancelled)
  |> Event.map(fun args -> args.Result)
  |> Event.add (printfn "%s")


type IDelegateEvent<'Del when 'Del :> Delegate> with
    member this.MySubscribe handler =
        this.AddHandler(handler)
        { new IDisposable with member x.Dispose() = this.RemoveHandler(handler) }