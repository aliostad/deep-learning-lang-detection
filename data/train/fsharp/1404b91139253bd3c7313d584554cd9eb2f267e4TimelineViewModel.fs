namespace MoonFlower.ViewModel

open System.Diagnostics
open ViewModule
open ViewModule.FSharp
open Mastonet.Entities
open MoonFlower.Model

type TimelineViewModel(account: YourAccount, api: TimelineAPI) as self =
    inherit ViewModelBase()

    let title = self.Factory.Backing(<@ self.Title @>, "untitled")
    let ss = self.Factory.Backing(<@ self.Statuses @>, Seq.empty)

    member this.Statuses with get() = ss.Value
                         and set(v) = ss.Value <- v

    member this.Title
        with get() = title.Value
        and set(v) = title.Value <- v
    member this.Fetch(): unit =
        async {
            let! ss = api.Get account.Client
            this.Statuses <- ss
            Seq.length ss
            |> sprintf "length: %d"
            |> Debug.WriteLine
        } |> Async.RunSynchronously
        this.RaisePropertyChanged(<@ this.Statuses @>)
