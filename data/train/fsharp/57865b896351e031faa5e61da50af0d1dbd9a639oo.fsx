
type Request () =
    member this.Test = "Request"

type IIdempotent =
    abstract member Print : unit -> string

type Foo () =
    inherit Request ()
    interface IIdempotent with
        member this.Print () = "Foo"

type Bar () =
    inherit Request ()
    interface IIdempotent with
        member this.Print () = "Bar"

let handle (req:Request) =
    match req with
    | :? Foo -> (req :?> Foo) :> IIdempotent
    | :? Bar -> (req :?> Bar) :> IIdempotent
    | _ -> failwith "unsupported type"

type handler<'R when 'R :> IIdempotent> () =
    static member Convert (req:'R) = 
        req :> IIdempotent

(handler.Convert (Foo())).Print ()

let convert<'R when 'R :> IIdempotent> (req:'R) =
        req :> IIdempotent

Bar () |> convert |> fun x -> x.Print ()