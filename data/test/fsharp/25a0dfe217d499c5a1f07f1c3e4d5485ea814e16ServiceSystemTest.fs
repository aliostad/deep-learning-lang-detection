namespace Cronix.Tests

open FsUnit.Xunit
open Xunit
open Cronix
open Chessie.ErrorHandling
open System
open System.Threading
open System.Collections.Generic
open System.Diagnostics 
open ServiceEnviroment   
open System.IO

[<Trait("Service", "Unit Test")>]
type SetupServiceTest() =
    
    [<Fact>]
    let ``load assemblies returns an array of dll names``() = 
        loadAssemblies()
        |> successTee (fun(obj : string[], _) -> obj |> Array.iter (fun(m:string) -> Console.WriteLine(m)))
        |> ignore
        ()

    [<Fact>]
    let ``get startup script returns success``() = 
        if IO.File.Exists("Startup.fsx.bak") then  IO.File.Move("Startup.fsx.bak", "Startup.fsx")
        match getStartupScript() with
         | Ok (script, msgs) -> script |> should not' NullOrEmptyString
         | Fail msgs -> failwith "Expected Success Tee"
         | _ -> ()


    [<Fact>]
    let ``get startup script returns failure``() = 
        if IO.File.Exists("Startup.fsx") then IO.File.Move("Startup.fsx", "Startup.fsx.bak")
        match getStartupScript() with
         | Ok (_, _) -> failwith "Expected Failure Tee"
         | Fail msgs -> IO.File.Move("Startup.fsx.bak", "Startup.fsx")
         | _ -> ()

        
    [<Fact>]
    let ``comlipe script returns success``() =

        let assemblies = 
            [|
                "Chessie.dll";
                "Cronix.Tests.dll";
                "Cronix.dll";
                "FSharp.Compiler.CodeDom.dll";
                "FSharp.Core.dll";
                "FsUnit.CustomMatchers.dll";
                "FsUnit.Xunit.dll";
                "NCrontab.dll";
                "NHamcrest.dll";
                "NLog.dll";
                "xunit.abstractions.dll";
                "xunit.dll";
                "xunit.runner.utility.desktop.dll";
                "xunit.runner.visualstudio.testadapter.dll";
                "System.dll";
            |]

        let result = compileScript({ source = IO.File.ReadAllText("Startup.fsx"); 
                        compiled = None;
                        referencedAssemblies = assemblies;
                        scheduleManager = new ScheduleManager() })

        match result with
        | Ok (state, msgs) -> ()
        | Fail msgs -> failwith "Expected Success Tee"
        | _ -> ()

    [<Fact>]
    let ``compile script returns failure when exception is thrown``() = 
        let result = compileScript({ source = IO.File.ReadAllText("Startup.fsx"); 
                                     compiled = None;
                                     referencedAssemblies = [||];
                                     scheduleManager = new ScheduleManager() })
        match result with
         | Ok (_, _) -> failwith "Expected Failure Tee"
         | Fail msgs -> msgs.[0] |> should startWith "Failed to compile startup script."
                        msgs.[0]


[<Trait("Service", "System Test")>]
type ServiceSystemTest() =
    let result = new List<string>()
    let mutable process' : Process = null
    do
        uninstallService()

    let createProcess (enviromentName) (parameter) = 
        let targetPath = getTargetPath enviromentName
        let executable = System.IO.Path.Combine(targetPath, executable)
        let startInfo = new ProcessStartInfo()
        startInfo.WindowStyle <- System.Diagnostics.ProcessWindowStyle.Normal
        startInfo.FileName <- executable
        if parameter <> null then startInfo.Arguments <- parameter
        startInfo.RedirectStandardOutput <- true
        startInfo.RedirectStandardInput <- true
        startInfo.UseShellExecute <- false
              
        process' <- Process.Start(startInfo)
        process'.BeginOutputReadLine() |> ignore
        process'.OutputDataReceived.Add(fun(args) -> 
            Console.WriteLine("event: {0} {1}", args.Data, DateTime.Now)
            result.Add(args.Data))     
                            
    let exit() = 
        process'.StandardInput.WriteLine("exit") |> ignore
            
    let wait() = process'.WaitForExit(10000) |> ignore

    let rec searchInLogFile enviroment message till =
        Thread.Sleep(200) |> ignore
        if till > DateTime.UtcNow then
            let dir = getTargetPath enviroment
            let logName = sprintf "%s.log" <| DateTime.Now.ToString("yyyy-MM-dd")
            let fileName = Path.Combine(dir, "logs", logName)
            if File.Exists fileName then
               let content = File.ReadAllText(fileName)
               if content.Contains(message) = false then searchInLogFile enviroment message till
            else 
                searchInLogFile enviroment message till
        else failwith <| sprintf "message '%s' not found." message

    [<Fact>]
    let ``Run in debug mode``() =
        createEnviroment "debugEnv"
        createProcess "debugEnv" "debug"
        Thread.Sleep(10000)
        exit()
        wait()
        result |> should contain "runService"

    [<Fact>]
    let ``Install service``() =
        createEnviroment "serviceEnv"
        createProcess "serviceEnv" "install"
        wait()
        result |> should contain "installed"

    [<Fact>]
    let ``Run installed service``() =
        createEnviroment "serviceEnv"
        createProcess "serviceEnv" "install"
        Thread.Sleep(5000)
        wait()
        result |> should contain "installed"
        startService()
        searchInLogFile "serviceEnv" "Trigger<'job1'> has been executed." <| DateTime.UtcNow.AddMinutes 2.0

    [<Fact>]
    let ``Rollback instalation on installation failure``() =
        createEnviroment "serviceEnv"
        createProcess "serviceEnv" "install"
        wait()
        createProcess "serviceEnv" "install"
        wait()
        result |> should contain "rollback: The specified service already exists"

    [<Fact>]
    let ``Uninstall service``() =
        createEnviroment "serviceEnv"
        createProcess "serviceEnv" "install"
        wait()
        createProcess "serviceEnv" "uninstall"
        wait()
        result |> should contain "uninstalled" 

    [<Fact>]
    let ``Print guide for invalid param``() =
        createEnviroment "serviceEnv"
        createProcess "serviceEnv" "?"
        wait()
        result |> should contain "printGuide" 

    [<Fact>]
    let ``Print guide for no param``() =
        createEnviroment "serviceEnv"
        createProcess "serviceEnv" ""
        wait()
        result |> should contain "printGuide" 

    interface IDisposable with
        member x.Dispose() =
            if process' <> null then
                if process'.HasExited = false then 
                    process'.Kill()|> ignore

            uninstallService()