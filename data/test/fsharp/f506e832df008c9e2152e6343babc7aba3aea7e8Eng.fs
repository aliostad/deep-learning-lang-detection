namespace Lizard

open System
open System.IO

module Eng = 
    ///send message to engine
    let Send(command:string, prc : System.Diagnostics.Process) = 
        prc.StandardInput.WriteLine(command)
    
    ///set up engine
    let ComputeAnswer(ln, depth, prc) = 
        Send("ucinewgame", prc)
        Send("setoption name Threads value " + (System.Environment.ProcessorCount - 1).ToString(), prc)
        Send("position startpos", prc)
        Send("position startpos moves " + ln + " ", prc)
        Send("go depth " + depth.ToString(), prc)
    
    ///set up process
    let SetUpPrc (prc : System.Diagnostics.Process) eng = 
        prc.StartInfo.CreateNoWindow <- true
        prc.StartInfo.FileName <- "stockfish.exe"
        prc.StartInfo.WorkingDirectory <- Path.GetDirectoryName
                                              (System.Reflection.Assembly.GetExecutingAssembly().Location)
        prc.StartInfo.RedirectStandardOutput <- true
        prc.StartInfo.UseShellExecute <- false
        prc.StartInfo.RedirectStandardInput <- true
        prc.StartInfo.WindowStyle <- System.Diagnostics.ProcessWindowStyle.Hidden
        prc.Start() |> ignore
        prc.BeginOutputReadLine()
    
    
