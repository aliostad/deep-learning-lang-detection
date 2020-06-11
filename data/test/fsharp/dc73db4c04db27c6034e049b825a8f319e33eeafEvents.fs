// $begin{copyright}
//
// This file is confidential and proprietary.
//
// Copyright (c) IntelliFactory, 2004-2012.
//
// All rights reserved.  Reproduction or use in whole or in part is
// prohibited without the written consent of the copyright holder.
//-----------------------------------------------------------------
// $end{copyright}

module WebSharper.JQuery.Mobile.Events

open WebSharper.InterfaceGenerator
open WebSharper.JQuery
type JEvent = WebSharper.JQuery.Event

let Handler0 = T<JEvent>?ev ^-> T<unit>
let Handler1 t = t ^-> T<unit>

let Event0 =
    let h = Handler0
    Class "Event"
    |+> Instance [
            "name" =? T<string>
            |> WithGetterInline "$this"
            "trigger" => T<JQuery>?jQ ^-> T<unit>
            |> WithInline "$jQ.trigger($this, $par)"
            "on" => T<JQuery>?jQ * h?handler ^-> T<unit>
            |> WithInline "$jQ.on($this, $handler)"
            "on" => T<JQuery>?jQ * T<string>?selector * h?handler ^-> T<unit>
            |> WithInline "$jQ.on($this, $selector, $handler)"
            "off" => T<JQuery>?jQ * h?handler ^-> T<unit>
            |> WithInline "$jQ.off($this, $handler)"
            "off" => T<JQuery>?jQ * T<string>?selector * h?handler ^-> T<unit>
            |> WithInline "$jQ.off($this, $selector, $handler)"
        ]

let Event1 =
    Generic - fun t ->
        let h = Handler1 t
        Class "Event`1"
        |+> Instance [
                "name" =? T<string>
                |> WithGetterInline "$this"
                "trigger" => T<JQuery>?jQ * t?par ^-> T<unit>
                |> WithInline "$jQ.trigger($this, $par)"
                "on" => T<JQuery>?jQ * h?handler ^-> T<unit>
                |> WithInline "$jQ.on($this, $handler)"
                "on" => T<JQuery>?jQ * T<string>?selector * h?handler ^-> T<unit>
                |> WithInline "$jQ.on($this, $selector, $handler)"
                "off" => T<JQuery>?jQ * h?handler ^-> T<unit>
                |> WithInline "$jQ.off($this, $handler)"
                "off" => T<JQuery>?jQ * T<string>?selector * h?handler ^-> T<unit>
                |> WithInline "$jQ.off($this, $selector, $handler)"
            ]

let Define name =
    name =? Event0
     |> WithGetterInline (sprintf @"'%s'" name)

let DefineTyped name (ty: Type.Type) =
    name =? Event1.[ty]
    |> WithGetterInline (sprintf "'%s'" name)
