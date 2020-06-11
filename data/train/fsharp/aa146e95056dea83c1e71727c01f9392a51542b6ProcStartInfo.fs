module ProcStartInfo

open System.Diagnostics
open Common.Bind

let msBuild() = @"c:\Program Files (x86)\MSBuild\14.0\Bin\MsBuild.exe"

let private getDefaultProcStartInfo fileName workingDir =
    let psi = ProcessStartInfo()
    psi.FileName <- fileName()
    psi.Arguments <- "/m"
    psi.WorkingDirectory <- workingDir
    psi.UseShellExecute <- false
    psi.RedirectStandardOutput <- true
    psi.RedirectStandardError <- true
    psi.CreateNoWindow <- true
    psi.WindowStyle <- ProcessWindowStyle.Hidden
    psi

let defaultProcStartInfo = getDefaultProcStartInfo msBuild
