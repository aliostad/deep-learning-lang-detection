namespace Gr1d.FSharp

open System
open System.Collections
open System.Collections.Generic
open System.Linq
open Gr1d.Api.Skill
open Gr1d.Api.Deck
open Gr1d.Api.Agent
open Gr1d.Api.Node

type Scout() =
    [<DefaultValue>] val mutable _deck : IDeck
    interface Gr1d.Api.Agent.IEngineer1 with
        member this.Initialise(deck) = 
            this._deck <- deck

        member this.Tick(agentUpdate) = 
            this.ApplyEffects(agentUpdate)
            if agentUpdate.Node.IsClaimable
            then ignore (this.Claim(agentUpdate.Node))
            ignore (this.Move(agentUpdate.Node.Exits.Values.FirstOrDefault()))

        member this.OnAttacked(attacker, agentUpdate) = 
            this.ApplyEffects(agentUpdate)
            ignore (this.Move(agentUpdate.Node.Exits.Values.Where(fun (n:INodeInformation) -> n.IsClaimable).FirstOrDefault()))

        member this.OnArrived(arriver, agentUpdate) = 
            this.ApplyEffects(agentUpdate)

    member this.ApplyEffects(agentUpdate : IAgentUpdateInfo) = 
        if not (agentUpdate.EffectFlags.HasFlag(AgentEffect.UnitTest))
        then ignore(this.UnitTest())
