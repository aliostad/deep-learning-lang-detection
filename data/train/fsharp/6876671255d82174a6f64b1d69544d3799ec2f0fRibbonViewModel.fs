namespace SafetyProgram.UI.ViewModels

open SafetyProgram.UI.Models
open Fluent
open System.Collections.ObjectModel
open SafetyProgram.Base.Helpers
open FSharpx.Option
open ReactiveUI
open System

type RibbonViewModel(documentTabGenerator : Option<GuiDocument> -> ObservableCollection<RibbonTabItem>,
                        selectionTabGenerator : GuiDocumentObject -> RibbonTabItem, 
                        model : GuiKernelData) as this = 

    let selectionRibbonTabs = new ObservableCollection<_>()

    let attachToSelection x =
        let selection = x.Content.Selection
        // When the selection changes clear the collection and add in new tabs.
        selection.CollectionChanged.Subscribe(fun _ ->
            selectionRibbonTabs.Clear()
            selection
            |> Seq.map selectionTabGenerator
            |> Seq.iter selectionRibbonTabs.Add)

    let propertyChanged = new Event<_,_>()

    let commands = new MainCommands(model)

    let getTabs =
        (<!>) (fun x -> x.Content)
        >> documentTabGenerator

    let mutable ribbonTabs = getTabs model.Content
    let mutable selectionHandler = attachToSelection <!> model.Content

    let handler = model.ContentChanged.Subscribe(fun _ ->
        ribbonTabs <- getTabs model.Content
        // Deattach from old selection container.
        Option.iter(fun (x : IDisposable) -> x.Dispose()) selectionHandler
        // Attach to new selection container.
        selectionHandler <- attachToSelection <!> model.Content
        raisePropChanged propertyChanged this "RibbonTabs")

    interface IRibbonViewModel with

        member this.RibbonTabs = ribbonTabs

        member this.Dispose() = 
            (commands :> IDisposable).Dispose()
            handler.Dispose()
            Option.iter(fun (x : IDisposable) -> x.Dispose()) selectionHandler

        member this.SelectionRibbonTabs = selectionRibbonTabs

        [<CLIEvent>]
        member this.PropertyChanged = propertyChanged.Publish

        member this.Commands = commands

    // IMPLICIT IMPL (COPY FROM IRibbonViewModel)
    member this.RibbonTabs = ribbonTabs

    member this.Dispose() = 
        (commands :> IDisposable).Dispose()
        handler.Dispose()
        Option.iter(fun (x : IDisposable) -> x.Dispose()) selectionHandler

    member this.SelectionRibbonTabs = selectionRibbonTabs

    [<CLIEvent>]
    member this.PropertyChanged = propertyChanged.Publish

    member this.Commands = commands