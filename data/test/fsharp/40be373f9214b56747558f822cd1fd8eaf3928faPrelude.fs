namespace Freya.Machines.Http.Machine.Specifications

open Aether
open Aether.Operators
open Freya.Core
open Freya.Core.Operators
open Freya.Machines
open Freya.Machines.Http
open Freya.Machines.Http.Machine.Configuration
open Freya.Types.Http
open Hephaestus

(* Prelude *)

(* Types *)

type Handler =
    Acceptable -> Freya<Representation>

(* Defaults *)

[<RequireQualifiedAccess>]
module Defaults =

    let methods =
        Set.ofList [
            GET
            HEAD
            OPTIONS ]

(* Resource *)

[<RequireQualifiedAccess>]
module internal Resource =

    let private liftOption =
            Freya.Value.liftOption

    let private charsets c =
            liftOption (c ^. Properties.Representation.charsets_)

    let private encodings c =
            liftOption (c ^. Properties.Representation.contentCodings_)

    let private mediaTypes c =
            liftOption (c ^. Properties.Representation.mediaTypes_)

    let private languages c =
            liftOption (c ^. Properties.Representation.languages_)

    let available c : Freya<Available> =
            fun charsets encodings mediaTypes languages ->
                { Charsets = charsets
                  Encodings = encodings
                  MediaTypes = mediaTypes
                  Languages = languages }
        <!> charsets c
        <*> encodings c
        <*> mediaTypes c
        <*> languages c

(* Decision

    Construction functions for building Decisions, either with a basic
    approach, or a more opinionated approach of drawing a possible
    decision from the configuration (using a supplied lens). In the
    opionated case, if the decision is not found in configuration, a
    static decision will be created from the supplied default value. *)

[<RequireQualifiedAccess>]
module internal Decision =

    let create (key, name) decision =
        Specification.Decision.create
            (Key.add [ name ] key)
            (decision >> Decision.map)

(* Terminal

   Construction functions for building Terminals, given a lens to the expected
   handler in the configuration, and an operation to apply prior to invoking
   the found handler (or invoking singly, in the case where a handler is not
   found in the configuration). *)

[<RequireQualifiedAccess>]
module internal Terminal =

    let create (key, name) operation handler =
        Specification.Terminal.create
            (Key.add [ name ] key)
            (fun configuration ->

                let operation =
                    operation configuration

                let handler =
                    match handler configuration with
                    | Some handler -> Representation.represent (Resource.available configuration) handler
                    | _ -> Freya.empty

                operation *> handler)