[<ReflectedDefinition>]
module Ionide.Yeoman

open System
open System.Text.RegularExpressions
open FunScript
open FunScript.TypeScript
open FunScript.TypeScript.fs
open FunScript.TypeScript.child_process
open FunScript.TypeScript.AtomCore
open FunScript.TypeScript.text_buffer
open Atom
open Atom.FSharp

[<ReflectedDefinition>]
module YeomanHandler =
    type generator = {
        run : string -> unit
    }

    let activate (gen : generator) =
        // Globals.atom.commands.add("atom-workspace", "F#:New-project", (fun _ -> gen.run "fsharp") |> unbox<Function>) |> ignore
        ()


type Yeoman() =

    member x.consumeYeomanEnvironment (gen : YeomanHandler.generator) =
        YeomanHandler.activate gen

    member x.activate(state:obj) =
        ()

    member x.deactivate() =
        ()
