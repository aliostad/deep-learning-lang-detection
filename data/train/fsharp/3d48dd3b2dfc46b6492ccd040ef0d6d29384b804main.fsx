#light

#load "src/common/fs/configuration.fsx"
#load "src/server/fs/information.fsx"
#load "src/common/fs/std.fsx"

namespace Hark.HarkPackageManager.Server.Starter

open System.Text.RegularExpressions
open System.IO.Compression
open System.Diagnostics
open System.Net.Sockets
open System.Text
open System.Net
open System.IO
open System

open Standard.Std
open Standard

module public Settings =
    open Configuration.File
    do settings <- readSettings (Path.Combine(Environment.HOME, ".hpmserver.ini"))
    
    let mutable port = getOr "Port" "60000" |> Parse.parseUInt16 |> Option.get
    let mutable scope = IPAddress.Any
    let mutable packageFilePath = getOr "PackageFilePath" "pks.hpm"
    
module public Methods =
    type ClientManager = delegate of Stream -> bool
    let mutable ManageClient : ClientManager = null
    
module private Execution =
    let start () =
        let manageClient (stream : Stream) = async {
            try
                while Methods.ManageClient.Invoke stream do
                    ()
            finally
                stream.Close()
        }
        
        let server = new TcpListener(Settings.scope, (int)Settings.port)
        server.Start()
        while true do
            let client = server.AcceptTcpClient()
            manageClient (client.GetStream())
            |> Async.Start
            
    let stop () =
        let currentProcess = Process.GetCurrentProcess()
        let currentProcessId = currentProcess.Id
        let currentProcessPath = currentProcess.MainModule.ModuleName
        for p in Process.GetProcesses() do
            try
                if p.MainModule.ModuleName = currentProcessPath && p.Id <> currentProcessId then
                    "Killing " + p.Id.ToString() |> Console.WriteLine
                    p.Kill()
                    p.WaitForExit()
            with
            | _ -> ()

module public EntryPoint =
    let displayStartHelp () =
        Std.displayHeader()
        console {
            return "Start command help"
            yield! [
                " ?                  :: Display this help"
                " -p / -port <port>  :: Defines the port to use"
                " -scope <scope>     :: Defines the scope of the server"
                "                     :   scope = any | local"
            ]
            return ""
        }
        
    let rec applySettings = function
    | [] -> true
    
    | "-p"::Parse.UInt16(port)::e
    | "-port"::Parse.UInt16(port)::e ->
        Settings.port <- port
        applySettings e
        
    | "-scope"::"any"::e ->
        Settings.scope <- IPAddress.Any
        applySettings e
    | "-scope"::"local"::e ->
        Settings.scope <- IPAddress.Loopback
        applySettings e
         
    | _ ->
        displayStartHelp()
        false
    
    let displayHelp () =
        Std.displayHeader()
        console {
            return "Usages"
            yield! [
                " " + information.APP_NAME + " start"
                " " + information.APP_NAME + " start ?"
                " " + information.APP_NAME + " stop"
            ]
            return ""
        }
        
    let rec mainl = function
    | "start"::queue ->
        if applySettings queue then
            Execution.start()
    | "restart"::queue ->
        if applySettings queue then
            Execution.stop()
            Execution.start()
    | "stop"::[] ->
        Execution.stop()
    | _ -> displayHelp()
    
    let main args = args |> Array.toList |> mainl

