open System.IO
open System.Diagnostics

let path = @"C:\folder\with\my\papers"
let fsw = new FileSystemWatcher(path,"*.tex")
fsw.Changed.Add(fun _ -> 
  fsw.EnableRaisingEvents <- false
  let ps = 
    ProcessStartInfo
      ( FileName = @"C:\full\path\to\pdflatex.exe",
        Arguments = "-interaction=nonstopmode my-paper-name.tex",
        WorkingDirectory = path,
        UseShellExecute = false,
        CreateNoWindow = true )
  let p = Process.Start(ps)
  p.WaitForExit()
  fsw.EnableRaisingEvents <- true )

fsw.EnableRaisingEvents <- true
