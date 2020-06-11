namespace Nessos.MBrace.Client
    
    open Nessos.Thespian

    open Nessos.MBrace

    type internal RuntimeMsg = Runtime.CommonAPI.Runtime
    type internal ProcessManagerMsg = Runtime.CommonAPI.ProcessManager
    type internal OSProcess = System.Diagnostics.Process
    
    [<CompilationRepresentationAttribute(CompilationRepresentationFlags.ModuleSuffix)>]
    module ProcessResult = 
        ///Represents the result of a process (pending, value, etc).
        type ProcessResult<'T> =
            | Pending
            | CompilerError of exn 
            | Value of 'T
            | Exception of exn
            | Fault of exn
            | Killed
        ///Represents the result of a process (pending, value, etc).
        and ProcessResult = ProcessResult<obj>
    
    module internal ProcessInfo = begin
        val getResult : info:Runtime.CommonAPI.ProcessInfo -> ProcessResult.ProcessResult<'T>
        val getReturnType : info:Runtime.CommonAPI.ProcessInfo -> System.Type
        val prettyPrint : (bool -> Runtime.CommonAPI.ProcessInfo list -> string)
    end
    
    ///The type representing a process submitted to the runtime.
    type Process =
        class
            internal new : info:Runtime.CommonAPI.ProcessInfo * processManager:ActorRef<ProcessManagerMsg> -> Process
            
            ///Wait for the process's result.
            member AwaitResultBoxed : unit -> obj

            ///<summary>Wait for the process's result.</summary>
            ///<param name="pollingInterval">The number of milliseconds to poll for a result.</param>
            member AwaitResultBoxedAsync : ?pollingInterval:int -> Async<obj>
            
            ///Cast to a strongly typed process.
            member Cast : unit -> Process<'T>

            ///Kills the current process.
            member Kill : unit -> unit

            ///<summary>Prints information about the process.</summary>
            ///<param name="useBorders">Enable fancy mySQL-like bordering.</param>
            member ShowInfo : ?useBorders:bool -> unit

            ///Tries to get the process's result.
            member TryGetResultBoxed : unit -> obj option
            
            member ClientId : System.Guid
            
            ///Gets whether the process if complete or not.
            member Complete : bool
            
            ///Gets the process's execution time.
            member ExecutionTime : System.TimeSpan
            
            ///Gets the process's start time.
            member InitTime : System.DateTime

            ///Gets the process's name.
            member Name : string

            ///Gets the process's identifier.
            member ProcessId : Runtime.CommonAPI.ProcessId

            member internal ProcessInfo : Runtime.CommonAPI.ProcessInfo
            
            ///Gets the process's result.
            member Result : ProcessResult.ProcessResult

            ///Get the process's return type.
            member ReturnType : System.Type

            ///The number of tasks currently created by the process.
            member Tasks : int

            ///Gets the number of workers currently used by the process.
            member Workers : int

            ///Cast to a strongly typed process.
            static member Cast : p:Process -> Process<'T>
        end

    ///The type representing a process submitted to the runtime.
    and [<SealedAttribute ()>] Process<'T> =
        class
            inherit Process
            internal new : info:Runtime.CommonAPI.ProcessInfo * processManager:ActorRef<ProcessManagerMsg> -> Process<'T>
            ///Wait for the process's result.
            member AwaitResult<'T> : unit -> 'T
            
            ///<summary>Waits for the process's result.</summary>
            ///<param name="pollingInterval">The number of milliseconds to poll for a result.</param>
            member AwaitResultAsync<'T> : ?pollingInterval:int -> Async<'T>
            
            ///Tries to get the process's result.
            member TryGetResult<'T> : unit -> 'T option
        end

    [<SealedAttribute ()>]
    type internal ProcessManager =
        class
            interface System.IDisposable
            internal new : runtime:ActorRef<Runtime.CommonAPI.ClientRuntimeProxy> ->
                                             ProcessManager
            member ClearAllProcessInfo : unit -> unit
            member ClearProcessInfo : pid:Runtime.CommonAPI.ProcessId -> unit
            member CreateProcess : expr:CloudComputation<'T> -> Process<'T>
            member CreateProcessAsync : comp:CloudComputation<'T> -> Async<Process<'T>>
            member GetAllProcesses : unit -> Process list
            member GetProcess : pid:Runtime.CommonAPI.ProcessId -> Process
            member GetProcess : pid:Runtime.CommonAPI.ProcessId -> Process<'T>
            member Kill : pid:Runtime.CommonAPI.ProcessId -> unit
            member KillAsync : pid:Runtime.CommonAPI.ProcessId -> Async<unit>
            member ShowInfo : ?useBorders:bool -> unit
        end
