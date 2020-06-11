// Copyright 2013 IntelliFactory
//
// Licensed under the Apache License, Version 2.0 (the "License"); you
// may not use this file except in compliance with the License.  You may
// obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied.  See the License for the specific language governing
// permissions and limitations under the License.

namespace IntelliFactory.Core

open System
open System.Collections
open System.Diagnostics
open System.IO
open System.Runtime
open System.Runtime.CompilerServices
open System.Security
open System.Text
open System.Threading
open System.Threading.Tasks
open IntelliFactory.Core

#nowarn "40"

type ProcessServiceMessage<'T> =
    | Dispose
    | Restart
    | Send of 'T
    | Start
    | Stop
    | Stopped
    | StopAsync of AsyncReplyChannel<unit>

type ProcessServiceAgent<'T> =
    {
        Self : MailboxProcessor<ProcessServiceMessage<'T>>
    }

type ProcessService<'T> =
    {
        ProcessServiceAgent : ProcessServiceAgent<'T>
        FinalizedFuture : Future<unit>
    }

    member s.MP = s.ProcessServiceAgent.Self
    member s.Post(m) = s.MP.Post(m)
    member s.Finalize() = s.Post Dispose; s.FinalizedFuture.Await()
    member s.Restart() = s.Post Restart
    member s.Start() = s.Post Start
    member s.Stop() = s.Post Stop
    member s.StopAsync() = s.MP.PostAndAsyncReply StopAsync
    member s.SendInput i = s.Post (Send i)
    member s.Disposed = s.FinalizedFuture

module ProcessService =

    type Config<'T> =
        {
            ProcessAgentConfig : ProcessAgent.Config<'T>
            RestartInterval : TimeSpan
        }

        member cfg.Configure(f: Config<'T> -> Config<'T>) =
            f cfg

    let startProcess opts =
        ProcessAgent.Start opts

    let defineAgent (allDone: Future<unit>) cfg agent =
        let opts = cfg.ProcessAgentConfig
        let restartInterval = cfg.RestartInterval
        let stop (p: ProcessAgent<'T>) =
            async {
                do p.Kill()
                let! c = p.ExitCode.Await()
                return ()
            }
        let finish proc =
            match proc with
            | None -> async.Return()
            | Some p -> stop p
        let rec idle () =
            async {
                let! msg = agent.Self.Receive()
                match msg with
                | Dispose -> return! finish None
                | Restart | Start -> return! start []
                | Send msg -> return! start [msg]
                | Send _ | Stop | Stopped -> return! idle ()
                | StopAsync k ->
                    do k.Reply()
                    return! idle ()
            }
        and running p =
            async {
                let! msg = agent.Self.Receive()
                match msg with
                | Dispose ->
                    return! finish (Some p)
                | Restart ->
                    do! stop p
                    return! start []
                | Start ->
                    return! running p
                | Send msg ->
                    do p.SendInput(msg)
                    return! running p
                | Stop ->
                    do! stop p
                    return! idle ()
                | StopAsync k ->
                    do! stop p
                    do k.Reply()
                    return! idle ()
                | Stopped ->
                    do! Async.Sleep(int restartInterval.TotalMilliseconds)
                    return! start []
            }
        and start messages =
            async {
                let p = startProcess opts
                do
                    p.ExitCode.On(fun code -> agent.Self.Post Stopped)
                    for m in messages do
                        p.SendInput m
                return! running p
            }
        async {
            try
                try
                    return! idle ()
                with e ->
                    return opts.Report e
            finally
                allDone.Complete()
        }

    let startAgent opts =
        let f = Future.Create()
        let start self = defineAgent f opts { Self = self }
        let mp = MailboxProcessor.Start(start)
        {
            ProcessServiceAgent = { Self = mp }
            FinalizedFuture = f
        }

    type Config<'T> with

        member this.Create() =
            ProcessAgent.Validate this.ProcessAgentConfig
            startAgent this

    let Configure mT toolPath =
        {
            ProcessAgentConfig = ProcessAgent.Configure mT toolPath
            RestartInterval = TimeSpan.FromSeconds(1.)
        }
