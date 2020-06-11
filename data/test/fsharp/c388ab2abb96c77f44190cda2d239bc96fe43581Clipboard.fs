namespace CopyStacker

open System
open System.Threading
open System.Runtime.InteropServices

open CopyStacker.CollectionUtil

module Clipboard =
    type ClipboardEvent = 
        | CopyEvent
        | SensitiveCopyEvent
        | PastePopEvent

    type ClipboardAction<'a> =
        | SendPaste
        | SetClipboardData of Data: 'a

    type CopyStackerState<'a> = { Stack: list<'a> }

    type CopyStackerResult<'a> = { State: CopyStackerState<'a>; Actions: ClipboardAction<'a> list }

    // TODO: Move this into CopyStackerState
    [<Literal>]
    let private MAX_ITEMS = 35

    let ProcessClipboardEvent(getClipboardData: unit -> 'a)(state: CopyStackerState<'a>, event: ClipboardEvent): CopyStackerResult<'a> =
        match event with
            | CopyEvent -> 
                let resultState = { Stack = getClipboardData()::state.Stack }
                { State = resultState; Actions = [] }
            | SensitiveCopyEvent -> 
                { State = state; Actions = [] } // Sensitive copy not yet implemented
            | PastePopEvent -> 
                match state.Stack with
                    | [] -> { State = state; Actions = [SendPaste] }
                    | [item] -> 
                        let resultState = { Stack = [] }
                        let actions = [SendPaste; SetClipboardData(item)]
                        { State = resultState; Actions = actions}
                    | head::tail ->
                        let resultState = { Stack = tail.Tail |> List.getRange(0, MAX_ITEMS) }
                        let actions = [SendPaste; SetClipboardData(tail.Head)]
                        { State = resultState; Actions = actions }