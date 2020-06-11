// Copyright (c) 2017 Intel Corporation. All rights reserved.
// Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

module rec IML.DeviceScannerDaemon.Server

open Fable.Import.Node
open Fable.Core
open Fable.Import.JS
open Fable.Core.JsInterop
open IML.LineDelimitedJsonStream.Stream
open IML.DeviceScannerDaemon.Handlers
open IML.DeviceScannerDaemon.EventTypes
open NodeHelpers

let serverHandler (c:Net.Socket) =
  c
    .pipe(getJsonStream())
    .on("error", fun (e:Error) ->
      console.error ("Unable to parse message " + e.message)
      c.``end``()
    )
    .on("data", (dataHandler (``end`` c)))
    |> ignore

let opts = createEmpty<Net.CreateServerOptions>
opts.allowHalfOpen <- Some true

let private server = Net.createServer(opts, serverHandler)
let private r e =
  e
  |> raise
  |> ignore

server.on("error", r)
  |> ignore

let private fd = createEmpty<Net.Fd>
fd.fd <- 3

server.listen(fd)
  |> ignore
