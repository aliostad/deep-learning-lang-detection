namespace UstbBox.App.Commands

open Reactive.Bindings
open System
open System.Windows.Input
open System.Linq
open System.Reactive.Linq
open System.Windows.Navigation
open System.Windows.Forms

type CopyCommands private () = 
    static let copy = new ReactiveCommand<obj>()
    static member val Copy : ICommand = copy :> ICommand
    static member Initialize() = 
        copy.Subscribe(fun x -> 
        Clipboard.SetDataObject(x)) |> ignore
//        goBack.Subscribe(fun _ -> NavigationService.Instance.GoBack()) |> ignore
//        goForward.Subscribe(fun _ -> NavigationService.Instance.GoForward()) |> ignore
//        navigateTo
//        |> Observable.filter (isNull >> not)
//        |> Observable.subscribe (fun t -> NavigationService.Instance.NavigateTo(t))
//        |> ignore
//        navigateToItem
//        |> Observable.filter (isNull >> not)
//        |> Observable.subscribe (fun t -> NavigationService.Instance.NavigateTo(t.Type, t.Parameter))
//        |> ignore
