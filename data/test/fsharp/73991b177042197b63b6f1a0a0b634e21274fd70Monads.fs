module Funky.Monads

let delay f = f
let delayNot f = f()

let tryWith handler body = try body() with e -> handler e

let tryFinally compensation body = try body() finally compensation ()

let using body (d: #System.IDisposable) =
    tryFinally
        (fun() -> if objRefEq d null |> not then d.Dispose())
        (fun() -> body d)

let while' zero bind body guard =
    let rec loop () =
        if guard() |> not then zero
        else body() |> bind loop
    loop()

let for' zero bind delay body (s: _ seq) =
    s.GetEnumerator() |> using (fun enum -> 
    enum.MoveNext |> while' zero bind (delay(fun () -> 
    body enum.Current)))
