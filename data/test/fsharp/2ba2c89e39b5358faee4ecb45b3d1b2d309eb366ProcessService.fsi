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
open System.Text

/// An agent that manages an operating system process, including automatically
/// starting it on first input and automaticlaly restarting it on failure.
[<Sealed>]
type ProcessService<'T> =

    /// Stops the internal process and finalizes everything.
    member Finalize : unit -> Async<unit>

    /// Stops and re-starts the process.
    member Restart : unit -> unit

    /// Sends text on the standard input. Starts the process if not started.
    member SendInput : 'T -> unit

    /// Starts the process, if in idle state. Does nothing if the process is already started.
    member Start : unit -> unit

    /// Stops the proces with `Kill`.
    member Stop : unit -> unit

    /// Stops the process and awaits until it is killed.
    member StopAsync : unit -> Async<unit>

module ProcessService =

    /// Options for `ProcessService`.
    type Config<'T> =
        {
            ProcessAgentConfig : ProcessAgent.Config<'T>
            RestartInterval : TimeSpan
        }

        /// Functionally updates the `ProcessHandleConfig` field.
        member Configure : (Config<'T> -> Config<'T>) -> Config<'T>

        /// Creates a `ProcessService` in stopped state.
        member Create : unit -> ProcessService<'T>

    /// Creates a new ProcessService. It will be started on first input or explicitly.
    val Configure : ProcessAgent.MessageType<'T> -> toolPath: string -> Config<'T>
