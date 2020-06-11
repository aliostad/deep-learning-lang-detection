namespace Fable.Import
open System
open System.Text.RegularExpressions
open Fable.Core
open Fable.Import.JS

module Mqtt =
    open Node.Events
    open Node.Stream

    type [<AllowNullLiteral>] Packet =
        abstract messageId: string with get, set
        [<Emit("$0[$1]{{=$2}}")>] abstract Item: key: string -> obj with get, set

    and [<AllowNullLiteral>] Granted =
        abstract topic: string with get, set
        abstract qos: float with get, set

    and [<AllowNullLiteral>] Topic =
        [<Emit("$0[$1]{{=$2}}")>] abstract Item: topic: string -> float with get, set

    and IClientOptions = interface end
    and IClientPublishOptions = interface end
    and IClientSubscribeOptions = interface end

    and [<AllowNullLiteral>] ClientSubscribeCallback =
        [<Emit("$0($1...)")>] abstract Invoke: err: obj * granted: Granted -> unit

    and [<AllowNullLiteral>] Client =
        inherit EventEmitter
        [<Emit("$0($1...)")>] abstract Invoke: streamBuilder: obj * options: IClientOptions -> Client
        abstract publish: topic: string * message: Buffer * ?options: IClientPublishOptions * ?callback: Function -> Client
        abstract publish: topic: string * message: string * ?options: IClientPublishOptions * ?callback: Function -> Client
        abstract subscribe: topic: string * ?options: IClientSubscribeOptions * ?callback: ClientSubscribeCallback -> Client
        abstract subscribe: topic: ResizeArray<string> * ?options: IClientSubscribeOptions * ?callback: ClientSubscribeCallback -> Client
        abstract subscribe: topic: Topic * ?options: IClientSubscribeOptions * ?callback: ClientSubscribeCallback -> Client
        abstract unsubscribe: topic: string * ?options: IClientSubscribeOptions * ?callback: ClientSubscribeCallback -> Client
        abstract unsubscribe: topic: ResizeArray<string> * ?options: IClientSubscribeOptions * ?callback: ClientSubscribeCallback -> Client
        abstract ``end``: ?force: bool * ?callback: Function -> Client
        abstract handleMessage: packet: Packet * callback: Function -> Client

    and [<AllowNullLiteral>] Store =
        abstract put: packet: Packet * callback: Function -> Store
        abstract get: packet: Packet * callback: Function -> Store
        abstract createStream: unit -> Readable<_>
        abstract del: packet: Packet * callback: Function -> Store
        abstract close: callback: Function -> unit

    and [<AllowNullLiteral>] Server =
        inherit EventEmitter

    type [<Import("mqtt","mqtt")>] Static =
        abstract connect: brokerUrl: string -> Client
        abstract connect: brokerUrl: string * opts: IClientOptions -> Client
