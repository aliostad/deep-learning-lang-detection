
module Giraffe.CurryTest
open FSharp.Core.Printf

// let v = 24
// let ipchar = 's'

// let casty (pchar:char) (a:string) (fn:'T -> unit ) = 
//     match pchar with
//     | 's' -> fn (a :> 'T)
//     | 'i' -> fn (int a :> 'T)


// let castInt = casty 's' "ted" (fun str -> printfn "%s" str)

type Binder1<'a>(fmt:StringFormat<'a -> unit,unit>, ifn: 'a -> unit) =

    member x.Bind(fn: string -> unit, part:string ) : unit =
        //let next = 
        part |> fn
        //x.Bind(next,part)

    member x.Bind(fn: int -> unit, part:string ) : unit =
        (int part) |> fn
        //x.Bind(next,part)

    // member x.Bind(fn: 'b -> unit, part:string ) : unit =
    //     Unchecked.defaultof<'b> |> fn
    // member x.Bind(fn: HttpHandler, part:string ) : HttpHandler =
    //     fn

    member x.Apply(path:string) : unit =
        x.Bind(ifn,path)

let test = Binder1("test%i",(fun i -> printfn ">>> %i" i ))
test.Apply("123")
