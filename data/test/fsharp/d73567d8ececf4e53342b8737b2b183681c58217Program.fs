module Program

open Catalogue
open System.Reflection
open System

[<EntryPoint>]
let main argv = 
    let unHandledExceptionHandler (args : UnhandledExceptionEventArgs) = 
        let e = args.ExceptionObject :?> Exception
        printException e
    AppDomain.CurrentDomain.UnhandledException.Subscribe unHandledExceptionHandler |> ignore
    log """
   ____      _        _                        
  / ___|__ _| |_ __ _| | ___   __ _ _   _  ___ 
 | |   / _` | __/ _` | |/ _ \ / _` | | | |/ _ \
 | |__| (_| | || (_| | | (_) | (_| | |_| |  __/
  \____\__,_|\__\__,_|_|\___/ \__, |\__,_|\___|
                              |___/            
"""
    log "Catalogue v%s" <| Assembly.GetExecutingAssembly().GetName().Version.ToString()
    printVerbose "Start directory: %s" Environment.CurrentDirectory
    Build.buildSite (argv)
    printVerbose "Exiting application with code: %i" Environment.ExitCode
    Environment.ExitCode
