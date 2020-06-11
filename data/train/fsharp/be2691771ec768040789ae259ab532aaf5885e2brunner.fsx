open System.IO
open System.Diagnostics

let path = @"C:\Tomas\Research\TypeProviders\icfp-2014-src\finals"
let fsw = new FileSystemWatcher(path,"*.tex")
fsw.Changed.Add(fun _ -> 
  fsw.EnableRaisingEvents <- false
  let ps = 
    ProcessStartInfo
      ( FileName = @"C:\Programs\Publishing\MiKTeX 2.9\miktex\bin\pdflatex.exe",
        Arguments = "-interaction=nonstopmode paper.tex",
        WorkingDirectory = path,
        UseShellExecute = false,
        CreateNoWindow = true )
  let p = Process.Start(ps)
  p.WaitForExit()
  fsw.EnableRaisingEvents <- true )

fsw.EnableRaisingEvents <- true


