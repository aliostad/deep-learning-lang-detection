module Itc.Tests.Processing
open Itc.Stamp

type Message =
    { text:string; stamp:Stamp }

type Process =
    { name:string; stamp:Stamp } with
    member this.CurrentStamp =
        peek this.stamp
    member this.Send text =
        let (s,anonymous) = send this.stamp
        let msg = {text=text; stamp=anonymous}
        printfn "%s snd '%s' with stamp:%s" this.name msg.text (print msg.stamp)
        (msg, {name=this.name; stamp=s})
    member this.Receive (msg:Message) =
        let s = receive this.stamp msg.stamp
        printfn "%s rcv '%s' with stamp:%s" this.name msg.text (print msg.stamp)
        {name=this.name; stamp=s}
    member this.Increment =
        let s = event this.stamp
        {name=this.name; stamp=s}

let CreateProcess(name,stamp) =
    {name=name;stamp=stamp}

let stampComparer (x:Process) (y:Process) =
    compare x.CurrentStamp y.CurrentStamp