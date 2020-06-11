// Copyright (c) 2017 Intel Corporation. All rights reserved.
// Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

module rec IML.DeviceScannerDaemon.Handlers

open Fable.Core.JsInterop
open Fable.PowerPack
open Fable.Import.Node
open System.Collections.Generic

open IML.DeviceScannerDaemon.EventTypes

let private deviceMap = Dictionary<DevPath, AddEvent>()

let dataHandler' (``end``:string option -> unit) = function
  | InfoEventMatch(_) ->
    ``end`` (Some (toJson deviceMap))
  | AddOrChangeEventMatch(x) ->
    deviceMap.Add (x.DEVPATH, x)
    ``end`` None
  | RemoveEventMatch(x) ->
    deviceMap.Remove x.DEVPATH |> ignore
    ``end`` None
  | _ ->
    ``end`` None
    raise (System.Exception "Handler got a bad match")

let dataHandler = dataHandler'
