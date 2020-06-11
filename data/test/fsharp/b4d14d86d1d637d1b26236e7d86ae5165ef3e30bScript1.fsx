let workingDir = sprintf @"%s\bin\debug" __SOURCE_DIRECTORY__
System.IO.Directory.SetCurrentDirectory( workingDir)
printfn "%s " workingDir;


//// TIP: sets the current directory to be same as the script directory
System.IO.Directory.SetCurrentDirectory (__SOURCE_DIRECTORY__)

#I @"C:\Workdir\Mine\InvestoBank.Execution\investobank.client\bin\debug"
#r @"InvestoBank.Execution.dll"
#r "UnionArgParser.dll"

open System;
open System.Collections.Generic

open InvestoBank.Execution.Broker
open InvestoBank.Execution.Domain;;
open InvestoBank.Execution.Abstractions;;
open InvestoBank.Execution.TradingPlatform;;

#load @"CLIArguments.fs"
open InvestoBank.Execution.Service.CmdLine;;
open Nessos.UnionArgParser;

let parser = UnionArgParser.Create<CLIArguments>();