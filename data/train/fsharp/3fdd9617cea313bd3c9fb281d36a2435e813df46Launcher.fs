namespace LauncherFs

type ProcessItem (item: LaunchItem) =
    member val Processes : System.Collections.Generic.List<System.Diagnostics.Process> = new System.Collections.Generic.List<System.Diagnostics.Process>()
    member val ChildProcesses : System.Collections.Generic.List<ProcessItem> = new System.Collections.Generic.List<ProcessItem>() with get, set
    member val StopSignal : bool = false with get, set
    static member runAll haltAll items =
        let processItems =
            items
            |> List.map (fun i -> new ProcessItem (i))
        processItems
        |> List.map (fun i -> i, (i.Start haltAll))

    member private this.LaunchInstance (haltAll: unit -> int) (instanceNum: int) =
        let workingDirectory =
            match item.StartProcess.WorkingDirectory |> System.String.IsNullOrEmpty with
            | true ->
                System.AppDomain.CurrentDomain.BaseDirectory
            | false ->
                match "." |> item.StartProcess.WorkingDirectory.IndexOf with
                | 0 -> //If it starts with "." means relative path
                    System.IO.Path.Combine (System.AppDomain.CurrentDomain.BaseDirectory, item.StartProcess.WorkingDirectory)
                | _ ->
                    item.StartProcess.WorkingDirectory
        let executablePath =
            match "." |> item.StartProcess.ExecutablePath.IndexOf with
            | 0 -> //If it starts with "." means relative path
                System.IO.Path.Combine (workingDirectory, item.StartProcess.ExecutablePath)
            | _ ->
                item.StartProcess.ExecutablePath
        let psi = new System.Diagnostics.ProcessStartInfo(
                    CreateNoWindow=true,
                    WindowStyle=System.Diagnostics.ProcessWindowStyle.Hidden,
                    UseShellExecute=false,
                    RedirectStandardOutput=true,
                    RedirectStandardError=true,
                    WorkingDirectory=workingDirectory,
                    FileName=executablePath,
                    Arguments=(item.StartProcess.Arguments |> String.concat " ")
                  )
        let startTime = System.DateTime.Now
        let stdOutput data =
            "[\"" + item.Description + "\" #" + (instanceNum |> string) + "]: " + data
            |> System.Console.WriteLine
        let errorOutput data =
            "[Error \"" + item.Description + "\" #" + (instanceNum |> string) + "]: " + data
            |> System.Console.WriteLine
        let proc = System.Diagnostics.Process.Start (psi, EnableRaisingEvents=true)
        match proc.HasExited with
        | true ->
            do
                (proc.WaitForExit ())
            match proc.ExitCode with
            | 0 ->
                (proc.StandardOutput.ReadToEnd ())
                |> stdOutput
                true
            | _ ->
                //If it already exited then something may be wrong
                (proc.StandardError.ReadToEnd ())
                |> errorOutput
                false
        | false -> //If it did not exit then attach events and return as true
            do
                (this.Processes.Add (proc))
            proc.Exited.Add (fun _ ->
                                    do
                                        proc
                                        |> this.Processes.Remove |> ignore
                                    match this.StopSignal, item.StopConfig.OnStopAction with
                                    | _, StopAction.Halt ->
                                        //Halt everything
                                        haltAll () |> ignore
                                        ()
                                    | false, StopAction.Relaunch ->
                                        let threshold = item.StopConfig.RelaunchTimeThreshold
                                        let relaunch =
                                            (((System.DateTime.Now - startTime).TotalMilliseconds |> System.Math.Round) |> int) >= threshold
                                        match relaunch with
                                        | false ->
                                            //Halt everything
                                            haltAll () |> ignore
                                            ()
                                        | true ->
                                            this.LaunchInstance haltAll (instanceNum) |> ignore
                                    | _ ->
                                        ()
                            )
            proc.ErrorDataReceived.Add(fun drea ->
                                            drea.Data
                                            |> errorOutput
                                      )
            proc.OutputDataReceived.Add(fun drea ->
                                            drea.Data
                                            |> stdOutput
                                       )
            (proc.BeginOutputReadLine ())
            true
    
    member private this.Launch (haltAll: unit -> int) =
        let instanceAmount =
            match item.InstanceConfig with
            | InstancesConfig.PerCpu ->
                System.Environment.ProcessorCount
            | InstancesConfig.Fixed ->
                item.FixedInstanceAmount
            | InstancesConfig.SingleInstance | _ ->
                1
        let launch = this.LaunchInstance haltAll
        seq { 1 .. instanceAmount}
        |> Seq.map launch
        |> Seq.forall (fun b -> b)

    member internal this.Start haltAll =
        let runDependents =
            match item.Status with
            | ItemStatus.Bypass ->
                true
            | ItemStatus.Enabled ->
                this.Launch haltAll
            | _ ->
                false
        match runDependents with
        | false ->
            true
        | true ->
            let dependents =
                item.Dependents
                |> ProcessItem.runAll haltAll
            let result =
                dependents
                |> Seq.exists (fun (pi, r) -> r |> not)
                |> not
            this.ChildProcesses <- new System.Collections.Generic.List<ProcessItem>( dependents |> Seq.map (fun tup -> tup |> fst) )
            result

    member internal this.Stop () =
        //Kill children first
        do
            this.StopSignal <- true
            this.ChildProcesses
            |> Seq.iter (fun child -> (child.Stop ()))
            this.Processes
            |> Seq.iter (fun p ->
                            //TODO: Check if it has to die with command or with kill
                            p.Kill ()
                        )


type Launcher (config: string) =
    let configJson = System.IO.File.ReadAllText config
    let app = Newtonsoft.Json.JsonConvert.DeserializeObject<LauncherFs.Application>(configJson)
    member val ProcessItemList : ProcessItem System.Collections.Generic.List = null with get, set
    member public this.Start () =
        let processItemList =
            app.Items |> ProcessItem.runAll this.Stop
        match   processItemList 
                |> Seq.exists (fun (pi, res) -> res |> not)
                |> not //De Morgan anyone?
                with
        | false -> //Something failed, bring everything down
            processItemList
            |> Seq.filter (fun (pi, res) -> res )
            |> Seq.iter (fun (pi, _) -> pi.Stop ())
            1 //Error code
        | true ->
            do
                this.ProcessItemList <- new System.Collections.Generic.List<ProcessItem>( processItemList |> Seq.map (fun tup -> tup |> fst) )
            (this.Repl ()) //All ok
    member private this.Stop () =
        this.ProcessItemList
        |> Seq.iter (fun pitem -> (pitem.Stop ()) )
        0
    member public this.Install () =
        0
    member public this.UnInstall () =
        0
    member private this.Status () =
        0
    member private this.Repl () =
        let rec replLoop () =
            do
                "> "
                |> System.Console.Write
            match (System.Console.ReadLine ()) with
            | "stop" ->
                (this.Stop ())
            | _ ->
                "Invalid command"
                |> System.Console.WriteLine
                (replLoop ())
        (replLoop ())