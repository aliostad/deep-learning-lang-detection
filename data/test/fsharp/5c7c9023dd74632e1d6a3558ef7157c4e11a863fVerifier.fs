module Verifier
open System.Diagnostics
open System.IO
open Microsoft.Build.Utilities
open NUnit.Framework
open FsUnit

let Verify(assemblyPath2:string) =    
    let GetPathToPEVerify() =
        let peverifyPath = 
            Path.Combine(ToolLocationHelper.GetPathToDotNetFrameworkSdk(TargetDotNetFrameworkVersion.Version40), @"bin\NETFX 4.0 Tools\peverify.exe")
        peverifyPath
    let exePath = GetPathToPEVerify()
    let process' = Process.Start( ProcessStartInfo(exePath, "\"" + assemblyPath2 + "\"",
                                            RedirectStandardOutput = true,
                                            UseShellExecute = false,
                                            CreateNoWindow = true))
    process'.WaitForExit(10000)
    let readToEnd = process'.StandardOutput.ReadToEnd().Trim()
    let expectedString = sprintf "All Classes and Methods in %s Verified." assemblyPath2
    readToEnd |> should contain expectedString
    //Assert.IsTrue(readToEnd.Contains(expectedString)), readToEnd)