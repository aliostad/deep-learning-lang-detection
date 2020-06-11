namespace Estwald
open System

open Gr1d
open Gr1d.Api
open Gr1d.Api.Agent
open Gr1d.Api.Deck
open Gr1d.Api.Node
open Gr1d.Api.Skill

[<AbstractClass; Sealed>]
type RNG private() =
    static let rnd = new Random()
    static member Next(maxValue) = rnd.Next(maxValue)

module Seq =
    let contains item (source : seq<'T>) =
        source |> Seq.exists(fun e -> e = item)
    
    let tryFirst(source : seq<'T>) =
        source |> Seq.tryFind(fun e -> true)

module Extensions =
    let negate fn = fun x -> not(fn(x))

    type IDeck with
        member d.TraceInfo(message) = 
            d.Trace(message, TraceType.Information)
        member d.TraceInfo(message, [<ParamArray>] args) =
            d.Trace(message, TraceType.Information, args)

    type IAgentInfo with
        member ai.IsPinned
            with get() = ai.Effects |> Seq.contains(AgentEffect.Pin)
        member ai.IsUnitTested
            with get() = ai.Effects |> Seq.contains(AgentEffect.UnitTest)