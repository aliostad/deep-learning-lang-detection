namespace Nessos.MBrace.Core

    open System
    open System.Collections.Generic
    
    open Nessos.MBrace

    // TODO : change

//    type LogEntry =
//        | Trace of TraceInfo
//        | UserLogInfo of UserLogInfo
        //| SystemLog of string * LogLevel * DateTime

    type TraceInfo = 
        { 
            Line        : int option
            File        : string option
            Function    : string option
            Message     : string
            DateTime    : DateTime
            Environment : IDictionary<string, string>
            ProcessId   : ProcessId
            TaskId      : string
            Id          : int64
        }

    and UserLogInfo = {
            Message     : string
            DateTime    : DateTime
            ProcessId   : ProcessId
            TaskId      : string
            Id          : int64
        }

//    and LogLevel =
//        | Info
//        | Warning
//        | Error

    type ICloudLogger = 
        abstract LogUserInfo  : ProcessId * UserLogInfo -> unit
        abstract LogTraceInfo : ProcessId * TraceInfo   -> unit
        