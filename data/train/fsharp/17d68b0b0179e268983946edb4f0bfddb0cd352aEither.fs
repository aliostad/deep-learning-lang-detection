namespace Prelude.Monad

open System

open Prelude

module Either =


    type EitherBuilder() =

        member this.Bind(x, f) =
            match x with
            | Right x -> f x
            | Left x -> Left x

        member this.Delay f = f()

        member this.Return x = Right x

        member this.ReturnFrom (m: Either<_, _>) = m

        member this.Zero() = Right ()

        (*member this.TryWith(body, handler) =
            try this.ReturnFrom (body())
            with e -> handler e*)

        (*member this.Combine (a,b) =
            match a, b with
            | Right a', Right b' ->
                Right b'
            | Right a', Left b' ->
                Right a'
            | Left a', Right b' ->
                Left a'
            | Left a', Left b' ->
                Left a'*)

    let either = EitherBuilder()
