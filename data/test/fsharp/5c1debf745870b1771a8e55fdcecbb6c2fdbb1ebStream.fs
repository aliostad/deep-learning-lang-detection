module Tachyon.Stream
    open Tachyon.IStream
    open Tachyon.Atom

    let private buildEventStream (a : IStream<'a>) f =
        let e = new Event<'b>()
        let p = e.Publish

        a.addWatch (new Handler<_>(fun _ x -> f (e.Trigger) x))

        {
            new IStream<'b> with
                member x.addWatch h = p.AddHandler h
                member x.removeWatch h = p.RemoveHandler h
        }

    let map f a = buildEventStream a (fun t x -> t (f x))

    let filter f a = buildEventStream a (fun t x -> if f x then t x)

    let choose f a = buildEventStream a (fun t x ->
        match f x with
        | Some x -> t x
        | _ -> ())

    let scan f b a =
        let id = atom b
        buildEventStream a (fun t x -> t (id.swap (fun y -> f y x)))

    let subscribe f a = buildEventStream a (fun t x -> f x; t x)
