namespace Nessos.MBrace

    open System
    open System.Runtime.Serialization

    //
    // exceptions that are descendants of or contain MBrace.Exception are treated specially by the client.
    // for better readability, all descendants this exception type should be defined in the MBrace namespace.
    //

    [<AutoOpen>]
    module private ExceptionUtils =

        let inline write<'T> (sI : SerializationInfo) (name : string) (x : 'T) =
            sI.AddValue(name, x, typeof<'T>)

        let inline read<'T> (sI : SerializationInfo) (name : string) =
            sI.GetValue(name, typeof<'T>) :?> 'T

    [<Serializable>]
    /// The base type for all the MBrace system exceptions.
    type MBraceException =
        inherit System.Exception

        new () = { inherit System.Exception() }
        new (message : string, ?inner : exn) = 
            match inner with
            | None -> { inherit System.Exception(message) }
            | Some e -> { inherit System.Exception(message, e) }

        new (x : SerializationInfo, y : StreamingContext) = { inherit System.Exception(x, y) }

    [<Serializable>]
    /// Represents a failure in executing an operation in the underlying store.
    type StoreException = 
        inherit MBraceException
    
        new (msg : string, ?inner : exn) = { inherit MBraceException(msg, ?inner = inner) }
        new (x : SerializationInfo, y : StreamingContext) = { inherit MBraceException(x, y) }

    [<Serializable>]
    /// Represents a failure in executing a dereference operation in the cloud ref primitives.
    type NonExistentObjectStoreException(container : string, name : string) = 
        inherit StoreException(sprintf "Object %s - %s has been disposed of or does not exist." container name)

        member __.Container with get () = container
        member __.Name      with get () = name

    [<Serializable>]
    /// Represents the fact that the system got in a corrupted state.
    type SystemCorruptedException =
        inherit MBraceException

        new (msg : string, ?inner : exn) = { inherit MBraceException(msg, ?inner = inner) }
        new (x : SerializationInfo, y : StreamingContext) = { inherit MBraceException(x, y) }

    [<Serializable>]
    type SystemFailedException =
        inherit MBraceException

        new (msg : string, ?inner : exn) = { inherit MBraceException(msg, ?inner = inner) }
        new (x : SerializationInfo, y : StreamingContext) = { inherit MBraceException(x, y) }

    [<Serializable>]
    type CompilerException = 
        inherit MBraceException

        new (msg : string, ?inner : exn) = { inherit MBraceException(msg, ?inner = inner) }
        new (x : SerializationInfo, y : StreamingContext) = { inherit MBraceException(x, y) }

    [<Serializable>]
    /// Represents a failure to obtain a process' result because the process was killed.
    type ProcessKilledException =
        inherit MBraceException
            
        new (msg : string, ?inner : exn) = { inherit MBraceException(msg, ?inner = inner) }
        new (x : SerializationInfo, y : StreamingContext) = { inherit MBraceException(x, y) }


    [<Serializable>]
    /// Represents an exception thrown by user code.
    type CloudException =
        inherit MBraceException

        val private processId : ProcessId
        val private context : CloudDumpContext option

        internal new(message : string, processId : ProcessId, ?inner : exn, ?context : CloudDumpContext) =
            {
                inherit MBraceException(message, ?inner = inner)
                processId = processId
                context = context
            }

        internal new (inner : exn, processId : ProcessId, ?context : CloudDumpContext) =
            let message = sprintf "%s: %s" (inner.GetType().FullName) inner.Message
            CloudException(message, processId, inner = inner, ?context = context)

        internal new (si : SerializationInfo, sc : StreamingContext) =
            {
                inherit MBraceException(si, sc)
                processId = read<ProcessId> si "processId"
                context = read<CloudDumpContext option> si "cloudDumpContext"
            }

        // TODO: implement a symbolic trace
//        member __.Trace = inner.StackTrace
        member e.ProcessId = e.processId
        member e.File = match e.context with Some c -> c.File | None -> "unknown"
        member e.FunctionName = match e.context with Some c -> c.FunctionName | None -> "unknown"
        member e.StartPos = match e.context with Some c -> c.Start | None -> (-1,-1)
        member e.EndPos = match e.context with Some c -> c.End | None -> (-1,-1)
        member e.Environment = match e.context with Some c -> c.Vars | None -> [||]
    
        override e.GetObjectData(si : SerializationInfo, sc : StreamingContext) =
            base.GetObjectData(si, sc)
            write<ProcessId> si "processId" e.processId
            write<CloudDumpContext option> si "cloudDumpContext" e.context

        interface ISerializable with
            member e.GetObjectData(si : SerializationInfo, sc : StreamingContext) = e.GetObjectData(si, sc)

//        override e.ToString() =
//            string {
//                yield sprintf' "MBrace.CloudException: %s\n" e.Message
//
//                yield sprintf' "--- Begin {m}brace dump ---\n"
//
//                yield sprintf' " Exception:\n" 
//                yield "  " + e.InnerException.ToString() + "\n"
//
//                match context with
//                | None -> ()
//                | Some ctx ->
//                    yield sprintf' " File: %s \n" ctx.File 
//                    yield sprintf' " Function: %s line: %A\n" ctx.FunctionName (fst ctx.Start)
//                    //yield sprintf' " CodeDump: %s \n" ctx.CodeDump // SECD Dump rethinking
//
//                    if ctx.Vars.Length > 0 then 
//                        yield sprintf' " Environment:\n"
//                        for name, value in ctx.Vars do
//                            yield sprintf' "\t\t %s -> %A\n" name value
//
//                yield sprintf' "--- End {m}brace dump ---\n"
//    
//                yield e.StackTrace
//            } |> String.build

    [<Serializable>]
    /// Represents one or more exceptions thrown by user code in a Cloud.Parallel context.
    type ParallelCloudException =

        inherit CloudException

        val private results : Result<ObjValue> []


        internal new(processId, results : Result<ObjValue> []) =
            {
                inherit CloudException("", processId)
                results = results
            }

        new (info : SerializationInfo, context : StreamingContext) =
            {
                inherit CloudException(info, context)
                results = read info "results"
            }

        member e.Results = e.results
        member e.Exceptions = e.results |> Array.choose (fun result -> match result with  ExceptionResult _ -> Some result | _ -> None) 
        member e.Values = e.results |> Array.choose (fun result -> match result with ValueResult _ -> Some result | _ -> None) 

        override e.ToString() = sprintf "%A" e.results // happy?

//                // workaround because of the FUUUUUUCKING string monad.
//                let mystring : obj -> string = sprintf "%A" // MAGIC
                
//                results
//                |> Array.map (function 
//                    | (ValueResult v) -> 
//                        match v with 
//                        | CloudRefValue o -> sprintf "ValueResult (%A)" o.Value 
//                        | _ as x -> x.ToString()
//                    | _ as e -> e.ToString())
//                |> sprintf "%O"
//
//
        override e.GetObjectData(info : SerializationInfo, context : StreamingContext) : unit =
            base.GetObjectData(info, context)
            write info "results" e.results

        interface ISerializable with      
            override e.GetObjectData(info : SerializationInfo, context : StreamingContext) : unit = e.GetObjectData(info, context)