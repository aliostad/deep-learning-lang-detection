open System.Diagnostics
open System.IO
open System.Threading

let inline asOptionBy f v = match f v with | null -> None; | _ -> Some v
let inline asOption v = asOptionBy id

// Something like Perl's exec - path to exe, comand line arguments, input stream
// returns a sequence of strings from StdOut.  
// note: Each enumeration will relaunch the process so cache if appropriate
let exec exePath exeArgs iSeq =
    seq {
        let pInfo = new ProcessStartInfo( exePath, 
                                          exeArgs, 
                                          CreateNoWindow = true, 
                                          UseShellExecute = false, 
                                          RedirectStandardInput = true, 
                                          RedirectStandardOutput = true)
        use p = Process.Start( pInfo )
        let cts = new CancellationTokenSource()
        let fwdInp = async {Seq.iter (fun (line:string) -> p.StandardInput.WriteLine(line) ) iSeq }

        // Start a task to feed the process input
        let task = Async.StartAsTask( fwdInp, cancellationToken = cts.Token )
                    .ContinueWith( (fun (t:Tasks.Task<unit>) -> p.StandardInput.Dispose()) )

        // Map the lines coming from the process into a sequence
        yield! Seq.unfold (fun (s:StreamReader) -> (s.ReadLine(),s) |> asOptionBy fst) p.StandardOutput
        cts.Cancel()
        task.Wait()
        }

// Print current ipv4 addresses sorted
exec "ipconfig" "" Seq.empty |> exec "findstr" "IPv4" |> exec "sort" "" |> Seq.iter (printfn "%s")
