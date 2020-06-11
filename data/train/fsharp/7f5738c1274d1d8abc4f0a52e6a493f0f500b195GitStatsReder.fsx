module GitStatsReder

open System.Diagnostics

let tee f x =
    f x |> ignore
    x

let startGitlog repoPath =
    ProcessStartInfo ()
    |> tee (fun i -> i.FileName <- "git.exe")
    |> tee (fun i -> i.WorkingDirectory <- repoPath)
    |> tee (fun i -> i.Arguments <- "log --stat")
    |> tee (fun i -> i.UseShellExecute <- false)
    |> tee (fun i -> i.RedirectStandardOutput <- true)
    |> tee (fun i -> i.CreateNoWindow <- true)
    |> Process.Start

let readGitStats repoPath =
    seq {
        let proc = startGitlog repoPath
        while not proc.StandardOutput.EndOfStream do
            yield proc.StandardOutput.ReadLine()
    }