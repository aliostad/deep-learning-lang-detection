namespace Nomad.Routing

open Nomad
open FParsec
open Microsoft.AspNetCore.Http

type private RParser<'a> = Parser<'a, unit>

module private SharedParsers =
    let endCond : RParser<unit> = skipChar '/' <|> eof

type private IRoute<'a, 'b> = 
    abstract member Run : 'b -> string -> ('a * string) option

type private ConstantRoute<'a>(constRoute : string) =
    interface IRoute<'a, 'a> with
        member this.Run a str =
            match run (skipString constRoute) str with
            |Success(res, _, pos) -> Some (a, (str.Substring(int <| pos.Index)))
            |_ -> None

type private ParseRoute<'a,'b>(parser : RParser<'b>) =
    interface IRoute<'a, 'b -> 'a> with
        member this.Run (f : 'b -> 'a) str =
            match run parser str with
            |Success(res, _, pos) -> Some (f res, (str.Substring(int <| pos.Index)))
            |_ -> None

type private EndOfRoute<'a>() =
    let parser : RParser<unit> = eof
    interface IRoute<'a, 'a> with
        member this.Run a str =
            match run parser str with
            |Success(res, _, pos) -> Some (a, (str.Substring(int <| pos.Index)))
            |_ -> None

type private PairRoute<'a,'b,'c>(one : IRoute<'b,'c>, two : IRoute<'a, 'b>) = 
    interface IRoute<'a, 'c> with
        member this.Run a str =
            one.Run a str
            |> Option.bind (fun (b, str') -> two.Run b str')

type Route<'a,'b> = private Route of IRoute<'a,'b>

[<AutoOpen>]
module Routing = 

    /// Match a route with a constant supplied path component
    let constant path : Route<'a,'a> = Route(ConstantRoute(path))

    let (</>) ((Route one) : Route<'b,'c>) ((Route two) : Route<'a, 'b>) : Route<'a, 'c> = 
        let (Route slash) = constant "/"
        let one' = PairRoute(one, slash)
        Route(PairRoute(one', two))

    let (<+>) ((Route one) : Route<'b,'c>) ((Route two) : Route<'a, 'b>) : Route<'a, 'c> = 
        Route(PairRoute(one, two))

    /// Match a string route component
    let strR<'a> : Route<'a, string -> 'a> = Route(ParseRoute(manyCharsTill anyChar SharedParsers.endCond))

    /// Match a signed integer route component
    let intR<'a> : Route<'a, int32 -> 'a>  = Route(ParseRoute(pint32))

    /// Match a signed 64-bit integer route component
    let int64R<'a> : Route<'a, int64 -> 'a> = Route(ParseRoute(pint64))

    /// Match an unsigned intenger route component
    let uintR<'a> : Route<'a, uint32 -> 'a>  = Route(ParseRoute(puint32))

    /// Match an unsigned 64-bit intenger route component
    let uint64R<'a> : Route<'a, uint64 -> 'a>  = Route(ParseRoute(puint64))

    /// Match a float route component
    let floatR<'a> : Route<'a, float -> 'a> = Route(ParseRoute(pfloat))

    /// Match a guid route component
    let guidR<'a> : Route<'a, System.Guid -> 'a> = Route(ParseRoute(many1Chars (hex <|> pchar '-') |>> System.Guid.Parse))

    let run ((Route route) : Route<'a,'b>) f str =
        route.Run f str

    let internal route ((Route route) : Route<HttpHandler<'a>,'b>) (handlerFunc : 'b) : HttpHandler<'a> =
        let (Route slash) = constant "/"
        let (Route route') = Route(PairRoute(PairRoute(slash, route),EndOfRoute()))
        let binder (ctx : HttpContext) =
            let path = ctx.Request.Path.Value
            match route'.Run handlerFunc path with
            |Some (v, _) -> v
            |None -> HttpHandler.unhandled
        InternalHandlers.askContext
        |> HttpHandler.bind binder

    /// Map the supplied typesafe route to the supplied handler function
    let ( ===> ) (rt : Route<HttpHandler<'a>,'b>) (handlerFunc : 'b) : HttpHandler<'a> =
        route rt handlerFunc

module HttpHandler =
    let route (rt : Route<HttpHandler<'a>,'b>) (handlerFunc : 'b) : HttpHandler<'a> =
        Routing.route rt handlerFunc