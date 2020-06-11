namespace Rexcfnghk.MarkSixParser

type ErrorMessage = ErrorMessage of string

[<StructuredFormatDisplay("{AsString}")>]
type ValidationResult<'a> =
    | Success of 'a
    | Error of ErrorMessage
    override this.ToString() =
        match this with
        | Success s -> sprintf "%A" s
        | Error e -> sprintf "%A" e
    member private this.AsString = this.ToString()

module ValidationResult =

    open Rexcfnghk.MarkSixParser.Utilities

    let success = Success

    let error = Error

    let errorFromString<'a> : string -> ValidationResult<'a> = ErrorMessage >> Error

    let doubleMap successHandler errorHandler = function
        | Success x -> successHandler x
        | Error e -> errorHandler e

    let rec retryable errorHandler f =
        match f () with
        | Success x -> x
        | Error e ->
            errorHandler e
            retryable errorHandler f

    let bind<'a, 'b> : ('a -> ValidationResult<'b>) -> ValidationResult<'a> -> ValidationResult<'b> =
        flip doubleMap Error

    let (>>=) x f = bind f x

    let map f = bind (f >> Success)

    let (<!>) = map

    let extract<'a> : ValidationResult<'a> -> 'a = doubleMap id (function ErrorMessage e -> invalidOp e)

    let (>=>) f g = f >> bind g

    let apply fV xV =
        match fV, xV with
        | Success f, Success x -> Success (f x)
        | Error e, _ | _, Error e -> Error e

    let (<*>) = apply

    // http://fsharpforfunandprofit.com/posts/elevated-world-4/#traverse
    let traverse f list =
        let cons h t = h :: t
        let folder h t = cons <!> (f h) <*> t
        List.foldBack folder list (Success [])
