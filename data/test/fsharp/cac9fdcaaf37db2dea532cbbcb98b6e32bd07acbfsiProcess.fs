namespace Tim.TryFSharp.Service

open System
open System.Diagnostics
open System.IO
open System.Text
open System.Threading
open Newtonsoft.Json
open Tim.TryFSharp.Core

type FsiProcessInfo =
    {
        Name : string
        InitTexts : (string * string) array
        Arguments : string array
        Print : string -> unit
        Recycle : unit -> unit
    }

type FsiProcess(info : FsiProcessInfo, proc : Process) =
    let standardInput = new StreamWriter(proc.StandardInput.BaseStream, UTF8Encoding(false), AutoFlush = true)
    let path = Path.Combine(Path.GetTempPath(), info.Name)

    let initTexts =
        let chars = Path.GetInvalidFileNameChars()

        [| for name, text in info.InitTexts ->
            let name =
                (name, chars)
                ||> Array.fold (fun name char -> name.Replace(char, '_'))

            Path.ChangeExtension(name, ".fsx"), text |]

    let syncRoot = obj()
    let buffer = ResizeArray<string>()

    let flush () =
        let s = lock syncRoot <| fun _ ->
            let s = String.concat "\n" buffer
            buffer.Clear()
            s

        info.Print s

    let recycleTimer = Timer.timer info.Recycle
    let flushTimer = Timer.timer flush

    let resetRecycleTimer () =
        ignore (Timer.at (TimeSpan.FromMinutes(10.0)) recycleTimer)

    let post (args : DataReceivedEventArgs) =
        if args.Data <> null then
            let immediateFlush =
                lock syncRoot <| fun _ ->
                    buffer.Add(args.Data)
                    buffer.Count > 100

            resetRecycleTimer ()
            if immediateFlush then
                flush ()
                ignore (Timer.never flushTimer)
            else
                ignore (Timer.at (TimeSpan.FromMilliseconds(100.0)) flushTimer)

    do
        resetRecycleTimer ()
        proc.OutputDataReceived.Add post
        proc.ErrorDataReceived.Add post

        ignore (Directory.CreateDirectory path)

        let arguments =
            [|
                yield "--utf8output"
                yield sprintf "-I:%s" (Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "assemblies"))
                yield! info.Arguments

                for name, text in initTexts do
                    let filename = Path.Combine(path, name)
                    File.WriteAllText(filename, text)
                    yield sprintf "--use:%s" filename
            |]

        let argumentsJson =
            let sb = StringBuilder()
            using (new StringWriter(sb)) <| fun textWriter ->
                use jsonWriter = new JsonTextWriter(textWriter, Formatting = Formatting.None)
                JsonSerializer().Serialize(jsonWriter, arguments)

            string (sb.Replace("\r", "").Replace("\n", ""))

        standardInput.WriteLine(argumentsJson)
        proc.BeginErrorReadLine()
        proc.BeginOutputReadLine()

    static member Start() : Process =
        let fileName = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Tim.TryFSharp.Interactive.exe")

        let fileName, arguments =
            match Type.GetType("Mono.Runtime") with
            | null -> fileName, [ ]
            | _ -> "mono", [ fileName ]

        let proc =
            new Process(
                StartInfo = ProcessStartInfo(
                    FileName = fileName,
                    RedirectStandardError = true,
                    RedirectStandardInput = true,
                    RedirectStandardOutput = true,
                    StandardErrorEncoding = Encoding.UTF8,
                    StandardOutputEncoding = Encoding.UTF8,
                    UseShellExecute = false))

        ignore (proc.Start())
        proc

    member this.StandardInput = standardInput
    member this.ProcessId = proc.Id

    interface IDisposable with
        member this.Dispose() =
            Log.info "Exiting fsi process %d" proc.Id
            standardInput.WriteLine("#quit;;")

            if not (proc.WaitForExit(5000)) then
                Log.info "Killing fsi process %d" proc.Id
                try
                    proc.Kill()
                    ignore (proc.WaitForExit(5000))
                with _ -> ()

            if proc.HasExited then
                Log.info "Fsi process %d exited with code %d" proc.Id proc.ExitCode
            else
                Log.info "Fsi process %d has not exited" proc.Id

            proc.Dispose()
            recycleTimer.Dispose()
            flushTimer.Dispose()
            flush ()
