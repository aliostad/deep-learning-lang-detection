namespace Rotix

open System
open System.Collections.Generic
open System.Reflection
open System.Text.RegularExpressions
open Mono.Reflection
open ChatExchangeDotNet

[<Sealed; AbstractClass; AttributeUsage(AttributeTargets.Method)>]
type HandlerAttribute (isPassive : bool) =
    inherit Attribute()
    member this.IsPassive = isPassive

[<AbstractClass>]
type ChatEventHandler() as this =
    let rec checkMethod meth =
        let insts = Disassembler.GetInstructions(meth)
        let calls = List<Instruction>()
        let success =
            insts
            |> Seq.exists (fun i ->
                match i.OpCode.Name with
                | "virtcall" | "callvirt" ->
                    let targetMethInfo = i.Operand :?> MethodInfo
                    if targetMethInfo.Module.Name = "ChatExchange.Net.dll" then
                        match targetMethInfo.Name with
                        | "get_PingableUsers"
                        | "get_CurrentUsers"
                        | "get_RoomOwners"
                            -> true
                        | _ -> false
                    else
                        false
                | "call" ->
                    let op = i.Operand :?> MethodInfo
                    // Make sure we stay in the same module as the caller.
                    if op.Module.Name = this.Handler.Module.Name then
                        calls.Add(i)
                    false
                | _ -> false
            )
        if not success && calls.Count > 0 then
            calls
            |> Seq.exists (fun call ->
                let meth = call.Operand :?> MethodInfo
                checkMethod meth
            )
        else
            success

    abstract member SubscribedRoomUrls : HashSet<string>

    abstract member SubscribedEvents : EventType[]

    abstract member MessageFilter : string

    abstract member Priority : UInt32

    default this.MessageFilter = ".*"

    default this.Priority = 0u

    member internal this.MessageFilterReg =
        Regex(this.MessageFilter, RegexOptions.Compiled ||| RegexOptions.CultureInvariant)

    member internal this.Handler : MethodInfo =
        let handlerType = this.GetType()
        let methodsWithAtt =
            handlerType.GetMethods()
            |> Array.filter (fun meth ->
                meth.CustomAttributes
                |> Seq.exists (fun att ->
                    att.AttributeType = typedefof<HandlerAttribute>
                )
            )
        match methodsWithAtt.Length with
        | 0 -> failwith "The specified ChatEventHandler does not contain any public methods marked with the 'Rotix.HandlerAttribute' attribute."
        | 1 -> Seq.head methodsWithAtt
        | _ -> failwith "The specified ChatEvenetHandler contains too many methods marked with the 'Rotix.HandlerAttribute' attribute. Only one method should be marked with this attribute."

    member internal this.HandlerParams = this.Handler.GetParameters()

    member internal this.HandlerArgKVs =
        this.HandlerParams
        |> Seq.map (fun p ->
            p.Name, p.ParameterType
        )

    member internal this.HasArg (name : string) (argType : Type) =
        this.HandlerArgKVs
        |> Seq.exists (fun a ->
            fst a = name && snd a = argType
        )

    member internal this.AccessesUserCollections() =
        checkMethod <| this.Handler