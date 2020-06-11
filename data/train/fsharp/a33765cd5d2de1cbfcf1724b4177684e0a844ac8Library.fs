module Fakeish

open Fake
open GetLine

let Colors = LineEditor.Colors(EntryColor = System.ConsoleColor.White, PromptColor = System.ConsoleColor.Magenta, CompletionColor = System.ConsoleColor.DarkGray)

let FakeishTarget (name:string) =
  let prompt (le : LineEditor) =
    le.Edit("fake> ", "")


  Target name (fun _ ->
    let targets =
      seq {
        yield "/lt"
        yield "/q"
        yield! Seq.filter (fun t -> t <> name) TargetDict.Keys
      }
    let matchFun (text:string) (_:int) =
      let matchTargets =
        targets
        |> Seq.filter (fun targ -> targ.StartsWith(text))
        |> Seq.map (fun targ -> targ.Substring(text.Length))
      LineEditor.Completion(text, (Seq.toArray matchTargets))
    let handler = LineEditor.AutoCompleteHandler matchFun
    let le = LineEditor("fakeish", Colors)
    le.AutoCompleteEvent <- handler

    let mutable line = prompt(le)
    while (line <> "/q") do
      try
        if (line = "/lt") then
          printf "targets: "
          Seq.iter (fun t -> printf "%A " t) targets
          printfn ""
        else
          runSingleTarget <| getTarget line
      with
        | ex -> printfn "%A" ex
      line <- prompt(le)
    exit 0
  )

