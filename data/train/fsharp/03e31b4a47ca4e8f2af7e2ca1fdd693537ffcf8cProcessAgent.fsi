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

// This stand-alone module implements an agent that can wrap a system
// process with a simple message-passing interface. It is parameterized
// to support reading/writing in text or binary mode (see MessageType).
// NOTE on orphan processes: when designing multi-process applications
// bear in mind that if the parent process may crash, the slave process
// typically lives on, becoming "orphan". If you are designing the slave
// process you can prevent this from happening by polling the host process.
namespace IntelliFactory.Core

open System
open System.Text

/// Represents a system process managed by an F# agent.
[<Sealed>]
type ProcessAgent<'T> =

    /// The exit code of the process.
    member ExitCode : Future<int>

    /// Sends a kill message that destroys the system process.
    member Kill : unit -> unit

    /// Sends a message via standard input.
    member SendInput : 'T -> unit

/// Operations with process agents.
module ProcessAgent =

    /// Represents a text or a binary message.
    [<Sealed>]
    type MessageType<'T>

    /// Constructors for message types.
    module MessageType =

        /// Text messages in ASCII.
        val ASCII : MessageType<string>

        /// Binary messages.
        val Binary : MessageType<byte[]>

        /// Text messages in a given encoding.
        val Text : Encoding -> MessageType<string>

        /// Text messages in UTF8.
        val UTF8 : MessageType<string>

    /// Configures a process agent.
    type Config<'T> =
        {
            /// Arguments passed to the process.
            Arguments : string

            /// Environment variables to set.
            EnvironmentVariables : Map<string,string>

            /// Path to the executable.
            FileName : string

            /// The message type (binary or text) to use.
            MessageType : MessageType<'T>

            /// Observes standard error.
            OnError : 'T -> unit

            /// Observes process exit event with a given code.
            OnExit : int -> unit

            /// Observes standard output.
            OnOutput : 'T -> unit

            /// Called with exceptions.
            Report : exn -> unit

            /// Working directory.
            WorkingDirectory : string
        }

    /// Validates configuration.
    val Validate : Config<'T> -> unit

    /// Creates a configuration object.
    val Configure : MessageType<'T> -> fileName: string -> Config<'T>

    /// Starts a process agent.
    val Start : Config<'T> -> ProcessAgent<'T>
