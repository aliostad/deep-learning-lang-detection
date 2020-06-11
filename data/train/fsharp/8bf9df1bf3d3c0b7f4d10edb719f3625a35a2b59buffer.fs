module Buffer

open Fable.Core

[<Import("*","buffer")>]
module buffer =
  type Buffer =
    abstract member length : int

type Buffer = buffer.Buffer

[<Emit("$0.length.valueOf()")>]
let length : Buffer -> int = fun b -> failwith "JS only"

[<Emit("new Buffer($0)")>]
let fresh : int -> Buffer = fun a -> failwith "JS only"

[<Emit("new Buffer($0)")>]
let fromArray : int array -> Buffer = fun a -> failwith "JS only"

[<Emit("$0")>]
let toArray : Buffer -> int array = fun a -> failwith "JS only"

[<Emit("(function (txt,enc) { var b = new Buffer(txt,enc); return b; })($0,$1)")>]
let fromString : string -> string -> Buffer = fun s e -> failwith "JS only"

[<Emit("$1.toString($0)")>]
let toString : string -> Buffer -> string = fun e b -> failwith "JS only"

[<Emit("$1[$0]")>]
let at : int -> Buffer -> int = fun i b -> failwith "JS only"

[<Emit("$0.equals($1)")>]
let equal : Buffer -> Buffer -> bool = fun a b -> failwith "JS only"

[<Emit("$0.compare($1)")>]
let compare : Buffer -> Buffer -> int = fun a b -> failwith "JS only"

[<Emit("$2.slice($0,$1)")>]
let slice : int -> int -> Buffer -> Buffer = fun s e b -> failwith "JS only"

[<Emit("(function() { var b = new Buffer($1); $2.copy(b,0,$0,$0+$1); return b; })()")>]
let dup : int -> int -> Buffer -> Buffer = fun s l b -> failwith "JS only"

[<Emit("(function() { var to = $0; var l = $1; var from = $2; var at = $3; var into = $4; from.copy(into,to,at,at+l); })()")>]
let copy : int -> int -> Buffer -> int -> Buffer -> unit = fun t l from at into -> failwith "JS"

[<Emit("$2.writeUInt16BE($1,$0)")>]
let writeUInt16BE : int -> int -> Buffer -> unit = fun at v b -> failwith "JS"

[<Emit("$1.readUInt16BE($0)")>]
let readUInt16BE : int -> Buffer -> int = fun at b -> failwith "JS"

[<Emit("new Buffer([])")>]
let empty : unit -> Buffer = fun _ -> failwith "JS"

[<Emit("new Buffer($0)")>]
let zero : int -> Buffer = fun n -> failwith "JS"
