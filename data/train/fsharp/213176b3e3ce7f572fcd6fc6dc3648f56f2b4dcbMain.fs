
namespace PacBio.ConsensusTools
open System
open PacBio.HDF
open PacBio.FSharp.Utils.Logging
open PacBio.FSharp.Utils.SubCommands
open PacBio.Utils
open PacBio.Data
open ManyConsole

module EntryPoint =

    type ConsensusTools() =
        static member Run args =
            let commands = ConsoleCommandDispatcher.FindCommandsInSameAssemblyAs typeof<ConsensusTools>
            ConsoleCommandDispatcher.DispatchCommand (commands, args, stdout)

    [<EntryPoint>]
    let main args =
        Console.WriteLine ("ConsensusTools {0}", BuildVersion.Copyright)

        if Seq.exists (fun a -> a.Equals "--version") args then
            Logger.Shutdown ()
            System.Environment.Exit <| int ProcessExitCode.Success

        let logger = Logger "ConsensusTools"
        let log lvl msg = logger.Log lvl msg
        let logf lvl fmt = logger.LogFormat lvl fmt

        let code =
            try
                log Info (System.Environment.GetCommandLineArgs () |> String.concat " ")
                let c = ConsensusTools.Run args

                // catch ManyConsole returning -1 for help commands
                let isHelp (a : string) = a.ToLower().Equals "help"
                if c = -1 && (Array.isEmpty args || isHelp args.[0]) then
                    Logger.Shutdown ()
                    System.Environment.Exit c

                if Enum.IsDefined (typeof<ProcessExitCode>, c) then
                    enum<ProcessExitCode> c
                else
                    ProcessExitCode.UnspecifiedError
            with
            | :? OptionException as ex ->
                log Fatal ex.Message
                ProcessExitCode.ArgumentError
            | :? ChemistryLookupException as ex ->
                log Fatal ex.Message
                ProcessExitCode.InvalidMetadata
#if DEBUG
            | _ as ex -> reraise ()
#else
            | :? OutOfMemoryException as ex ->
                log Fatal "Pipeline ran out of memory"
                logf Fatal "Working set size %d" System.Environment.WorkingSet
                logf Fatal "Out of memory: %s, stack trace: %s" ex.Message ex.StackTrace
                ProcessExitCode.OutOfMemory
            | :? HDFException as ex ->
                logf Fatal "HDF exception: %s, stack trace: %s" ex.Message ex.StackTrace
                if ex.Message.Contains "No space left on device" then
                    ProcessExitCode.DiskFull
                else
                    ProcessExitCode.SystemIOError
            | :? System.Threading.ThreadAbortException ->
                log Fatal "Protocol aborted"
                ProcessExitCode.UserInterrupt
            | :? System.IO.IOException as ex ->
                logf Fatal "Input/Output exception: %s" ex.Message
                ProcessExitCode.SystemIOError
            | _ as ex ->
                reraise ()
#endif

        let codeName = Enum.GetName (typeof<ProcessExitCode>, code)
        logf Info "Exiting with result: %i -- %s" (int code) codeName
        Logger.Shutdown ()

        int code
