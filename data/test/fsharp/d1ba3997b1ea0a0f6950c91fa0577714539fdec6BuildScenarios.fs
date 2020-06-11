module Totify.WebDeploy

open System

let totify_build =    
    let startInfo = new System.Diagnostics.ProcessStartInfo();
    startInfo.FileName <- @"D:\projects\totify\tools\FAKE\Fake.exe"
    startInfo.Arguments <- @"D:\projects\totify\build.fsx"
    startInfo.RedirectStandardOutput <- true
    startInfo.UseShellExecute <- false
    startInfo.WorkingDirectory <- @"D:\projects\totify\"
    use buildProcess = System.Diagnostics.Process.Start startInfo
    use reader = buildProcess.StandardOutput
    let result = reader.ReadToEnd()
    result