namespace QuickSearch

open System
open System.Diagnostics
open System.Text.RegularExpressions
open System.Threading
open Gtk
open MonoDevelop.Components
open MonoDevelop.Components.Commands
open MonoDevelop.Core.ProgressMonitoring
open MonoDevelop.Ide
open MonoDevelop.Ide.FindInFiles
open MonoDevelop.Core

type QuickSearchResult = { term:string; filePath: FilePath; line:int; offset: int; text:string; matchLength: int }

module QuickSearch =
    let isNotNull x = not (isNull x)
    let mutable token = new CancellationTokenSource()
    let resultEvent = Event<_>()
    let resultReceived = resultEvent.Publish
    let addResult term text =
        if isNotNull text then
            let m = Regex.Match(text, "(?<filename>[^:]*):(?<line>\d+):(?<offset>\d+):\s*(?<text>.*)", RegexOptions.Compiled)
            if m.Success then
                let offset = m.Groups.["offset"].Value |> int
                let filePath = m.Groups.["filename"].Value
                let line = m.Groups.["line"].Value |> int
                let textMatch = m.Groups.["text"].Value
                let result = { term=term; filePath=FilePath(filePath); offset=offset; line=line; text=textMatch; matchLength=text.Length }
                resultEvent.Trigger result

    let search term =
        LoggingService.LogDebug ("Searching for - " + term)
        token.Cancel()

        token <- new CancellationTokenSource()
        let getProcess args =
            LoggingService.LogDebug args
            let startInfo =
                new ProcessStartInfo
                    (FileName = "/bin/bash", UseShellExecute = false, Arguments = sprintf "-c '%s'" args,
                    RedirectStandardError = true, CreateNoWindow = true, RedirectStandardOutput = true,
                    RedirectStandardInput = true, StandardErrorEncoding = Text.Encoding.UTF8, StandardOutputEncoding = Text.Encoding.UTF8)

            try
                Process.Start(startInfo)
            with e ->
                MonoDevelop.Core.LoggingService.LogDebug (sprintf "Error starting QuickSearch %s" (e.ToString()))
                reraise()

        let killChildProcesses pid =
            getProcess (sprintf "kill -9 %d" pid) |> ignore

        let computation =
            async {
                let solution = 
                    IdeApp.Workspace.GetAllSolutions() |> Seq.head

                let solutionPath = solution.BaseDirectory |> string;

                let searchProcess = getProcess (sprintf "mdfind -onlyin %s %s | egrep --line-buffered \"\\\\.(cs|fs)$\" | xargs grep --line-buffered -inH --byte-offset %s" solutionPath term term)

                let outputDisposable =
                    searchProcess.OutputDataReceived
                    |> Observable.subscribe(fun x -> if isNotNull x then addResult term x.Data)

                use! c = Async.OnCancel (fun() -> LoggingService.LogDebug ("Search Process killed for term " + term)
                                                  if not searchProcess.HasExited then 
                                                      LoggingService.LogDebug (searchProcess.Id.ToString())
                                                      killChildProcesses searchProcess.Id
                                                      if not searchProcess.HasExited then
                                                          searchProcess.Kill()
                                                      outputDisposable.Dispose())

                searchProcess.EnableRaisingEvents <- true
                searchProcess.BeginOutputReadLine()
                searchProcess.WaitForExit()
                LoggingService.LogDebug ("Search for '" + term + "' finished")
            }
        Async.Start(computation, token.Token)
