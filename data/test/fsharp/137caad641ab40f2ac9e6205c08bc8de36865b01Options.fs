namespace Fasten
module Options =

    open System.IO
    open System.Diagnostics
    open System.Text.RegularExpressions

    open Fasten.Types

    [<NoComparison; NoEquality>]
    type CommandLineOptions = {
        buildProcedure : option<Command>
        externalProcessTimeout : int
        fastenableRegex : Regex
        fileRegex : Regex
        fitnessProcedure : option<Command>
        generations : int
        populationSize : int
        resetProcedure : option<Command>
        verbose : bool
    }

    let empty : CommandLineOptions = {
        buildProcedure = None
        externalProcessTimeout = 60 * 1000
        fastenableRegex = new Regex ("\\d+(?=\\s*/\\*\\s*(INT|POW|BOOL)\\s+FASTENABLE\\s*\\*/)")
        fileRegex = new Regex ("\\.c|\\.h")
        fitnessProcedure = None
        generations = 20
        populationSize = 20
        resetProcedure = None
        verbose = false
    }
    let runCommand (options : CommandLineOptions) (command : string) ()
        : option<string> =
        try
            use mutable ``process`` = new Process ()
            (* FIXME This regex is brittle, but I didn’t want to add separate
                command-line options for process arguments. *)
            let ``match`` = Regex.Match (command, "^(\\S+)(.*)$")
            let executable = ``match``.Groups.[1].Value
            let arguments = ``match``.Groups.[2].Value
            ``process``.StartInfo.FileName <- executable
            ``process``.StartInfo.Arguments <- arguments
            ``process``.StartInfo.UseShellExecute <- false
            ``process``.StartInfo.RedirectStandardOutput <- true
            ``process``.StartInfo.RedirectStandardError <- true
            ``process``.StartInfo.WorkingDirectory <-
                Directory.GetCurrentDirectory ()
            let output = new System.Text.StringBuilder ()
            let error = new System.Text.StringBuilder ()
            if ``process``.Start () then
                ``process``.OutputDataReceived.Add
                    (fun args -> output.Append(args.Data) |> ignore)
                ``process``.ErrorDataReceived.Add
                    (fun args -> error.Append(args.Data) |> ignore)
                ``process``.BeginErrorReadLine ()
                ``process``.BeginOutputReadLine ()
                if ``process``.WaitForExit options.externalProcessTimeout then
                    printfn "Standard Output:\n%s" (output.ToString ())
                    printfn "Standard Error:\n%s" (error.ToString ())
                    if ``process``.ExitCode = 0 then
                        Some (output.ToString ())
                    else
                        printfn
                            "Process failed with exit code %d. Output:\n%s\nErrors:\n%s"
                            ``process``.ExitCode
                            (output.ToString ())
                            (error.ToString ())
                        None
                else
                    printfn "Process timed out."
                    if not ``process``.HasExited then
                        ``process``.Kill ()
                    printfn "Output: %s" (output.ToString ())
                    printfn "Errors: %s" (error.ToString ())
                    (* Individuals that take too long to exercise are unfit! *)
                    None
            else Report.failedCommand command None
        with e -> Report.failedCommand command (Some (e.ToString ()))

    let parse
        : string list -> CommandLineOptions * string list =
        let rec
            go = fun ((options, unused) as acc) ->
                let proceed x y = go (x, unused) y in function
                | "--build" :: command :: rest ->
                    proceed
                        { options with buildProcedure = Some (runCommand options command) }
                        rest
                | "--build" :: [] ->
                    Report.invalidFlag "--build" "<command>"
                | "--files" :: pattern :: rest ->
                    proceed
                        { options with fileRegex = new Regex (pattern) }
                        rest
                | "--files" :: [] -> Report.invalidFlag "--files" "<regex>"
                | "--fitness" :: command :: rest ->
                    proceed
                        { options with fitnessProcedure = Some (runCommand options command) }
                        rest
                | "--fitness" :: [] ->
                    Report.invalidFlag "--fitness" "<command>"
                | "--generations" :: size :: rest ->
                    proceed
                        { options with generations = System.Int32.Parse size }
                        rest
                | "--generations" :: [] ->
                    Report.invalidFlag "--generations" "<count>"
                | "--help" :: _ ->
                    Report.usage ()
                | "--population" :: size :: rest ->
                    proceed
                        { options with populationSize = System.Int32.Parse size }
                        rest
                | "--population" :: [] ->
                    Report.invalidFlag "--population" "<size>"
                | "--reset" :: command :: rest ->
                    proceed
                        { options with resetProcedure = Some (runCommand options command) }
                        rest
                | "--reset" :: [] ->
                    Report.invalidFlag "--reset" "<command>"
                | "--timeout" :: milliseconds :: rest ->
                    proceed
                        { options with externalProcessTimeout = System.Int32.Parse milliseconds }
                        rest
                | "--timeout" :: [] ->
                    Report.invalidFlag "--timeout" "<milliseconds>"
                | "--verbose" :: rest ->
                    proceed
                        { options with verbose = true }
                        rest
                | x :: rest ->
                    go (options, x :: unused) rest
                | [] -> acc
        go (empty, [])
