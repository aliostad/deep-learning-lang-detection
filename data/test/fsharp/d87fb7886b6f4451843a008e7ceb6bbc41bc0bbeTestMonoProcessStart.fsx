
#load "Env.fs"
#load "CmdLineParsing.fs"
open ClusterManagement

open System.Diagnostics

let cmd = [| "-c"; "echo \"\\\"\\`'\\$(ARCH)\"" |] // should print "`'$(ARCH)
          |> Arguments.OfArgs


let bashWindows = @"C:\Program Files\Git\usr\bin\bash.exe"
let bashUnix = "/bin/bash"

// we want to execute /bin/bash -c "echo \"\\$(ARCH)\""
// to output "$(ARCH)"
// Convert via https://github.com/dotnet/corefx/blob/master/src/System.Diagnostics.Process/src/System/Diagnostics/Process.Unix.cs#L443-L522
// Documentation: https://msdn.microsoft.com/en-us/library/17w5ykft.aspx
let fixUnix (cmdLine:string) =  cmdLine.Replace("\\$", "\\\\$").Replace("\\`", "\\\\`")
let s = ProcessStartInfo(bashUnix, fixUnix cmd.ToStartInfo)
//let s = ProcessStartInfo(bashWindows, cmd.ToStartInfo)
s.RedirectStandardOutput <- true
s.UseShellExecute <- false
let p = Process.Start(s)
printfn "Output: %s" (p.StandardOutput.ReadToEnd())
p.WaitForExit()

