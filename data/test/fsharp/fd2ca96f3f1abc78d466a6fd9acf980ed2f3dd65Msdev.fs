namespace FsiTools


open System

(*----------------------------------------------------------------------------*)
//http://fortysix-and-two.blogspot.com/2010/05/accessing-visual-studios-automation-api.html

open EnvDTE
open EnvDTE80
open EnvDTE90
open System.Runtime.InteropServices
open System.Runtime.InteropServices.ComTypes
open System.IO
open System.Diagnostics

module Msdev =
    [<DllImport("ole32.dll")>]  
    extern int GetRunningObjectTable([<In>]int reserved, [<Out>] IRunningObjectTable& prot)
 
    [<DllImport("ole32.dll")>]  
    extern int CreateBindCtx([<In>]int reserved,  [<Out>]IBindCtx& ppbc)

    let tryFindInRunningObjectTable (name:string) =
        //let result = new Dictionary<_,_>()
        let mutable rot = null
        if GetRunningObjectTable(0,&rot) <> 0 then failwith "GetRunningObjectTable failed."
        let mutable monikerEnumerator = null
        rot.EnumRunning(&monikerEnumerator)
        monikerEnumerator.Reset()
        let mutable numFetched = IntPtr.Zero
        let monikers = Array.init<ComTypes.IMoniker> 1 (fun _ -> null)
        let mutable result = None
        while result.IsNone && (monikerEnumerator.Next(1, monikers, numFetched) = 0) do
            let mutable ctx = null
            if CreateBindCtx(0, &ctx) <> 0 then failwith "CreateBindCtx failed"
                
            let mutable runningObjectName = null
            monikers.[0].GetDisplayName(ctx, null, &runningObjectName)
            
            if runningObjectName = name then
                let mutable runningObjectVal = null
                if rot.GetObject( monikers.[0], &runningObjectVal) <> 0 then failwith "GetObject failed"
                result <- Some runningObjectVal
            
            if (runningObjectName.IndexOf("VisualStudio",StringComparison.InvariantCultureIgnoreCase) >= 0) then
                printfn "found running object: %s" runningObjectName 
            //result.[runningObjectName] <- runningObjectVal
        result

    let getParentProcess (pid:int ) =
        let processName = Process.GetProcessById(pid).ProcessName;
        let processesByName = Process.GetProcessesByName(processName);
        let mutable processIndexdName = null;

        let procName = 
            processesByName
            |> Seq.mapi (fun i p ->
                match i with 
                | 0 -> p.ProcessName
                | i -> sprintf "%s#%d" p.ProcessName i)
            |> Seq.tryFind (fun processIndexedName -> 
                let idProcess = new PerformanceCounter("Process", "ID Process", processIndexedName)
                let procId = idProcess.NextValue() |> int
                procId = pid) 

        match procName with
        | None -> -1
        | Some name -> 
            let parentId = new PerformanceCounter("Process", "Creating Process ID", name)
            parentId.NextValue() |> int

    let currentProcessId = Process.GetCurrentProcess().Id
    
    let DTE = 
        let myVS = getParentProcess currentProcessId 
        let getVS2008ROTName id = sprintf "!VisualStudio.DTE.12.0:%i" id
        (tryFindInRunningObjectTable (getVS2008ROTName myVS) |> Option.get) :?> DTE2

    let fullOutputPath = 
        let proj = (DTE.ActiveSolutionProjects :?> obj array ).[0] :?> Project 
        let fullPath = proj.Properties.["FullPath"].Value :?> string
        let outputPath = proj.ConfigurationManager.ActiveConfiguration.Properties.["OutputPath"].Value :?> string
        Path.Combine(fullPath,outputPath)

    let attachPid (pid : int) =
        let proc = 
            DTE.Debugger.LocalProcesses 
            |> Seq.cast<EnvDTE.Process>
            |> Seq.tryFind (fun p -> p.ProcessID = pid)
        match proc with
        | Some p -> p.Attach()
        | None -> printfn "Cannot attach to PID: %d" pid

    let attach() = attachPid currentProcessId        