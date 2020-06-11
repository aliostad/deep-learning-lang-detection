// Given a typical setup (with 'FSharp.Formatting' referenced using NuGet),
// the following will include binaries and load the literate script
#load @"packages/FSharp.Formatting.2.10.0/FSharp.Formatting.fsx"
#I "packages/RazorEngine/lib/net40"
#I "packages/FSharp.Formatting.2.10.0/lib/net40"
open System.IO
open FSharp.Literate

/// Return path relative to the current file location
let relative subdir = Path.Combine(__SOURCE_DIRECTORY__, subdir)

/// Processes a single F# Script file and produce HTML output
let processScriptAsHtml () =
  let file = relative "anagram.fsx"
  let template = relative @"content/template-file.html"
  let output = relative @"content/index.html"
  Literate.ProcessScriptFile(file, template, output)
