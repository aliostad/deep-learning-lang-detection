#I "../packages/FSharp.Formatting.1.0.14/lib/net40"
#load "../packages/FSharp.Formatting.1.0.14/literate/literate.fsx"
open FSharp.Literate
open System.IO
// Load the template & specify project information
let source = __SOURCE_DIRECTORY__
let template = source + "/template-project.html"
let projInfo =
  [ "page-description", "Flow"
    "page-author", "Johan Verwey"
    "github-link", "https://github.com/rookboom/Flow"
    "project-name", "Flow"]
// Process all files and save results to 'output' directory
let processProject project =
    let dir = sprintf "%s\\..\\%s" source project
    System.Console.WriteLine(dir)
    Literate.ProcessDirectory
        (dir, template, source + "\\output", 
        replacements = projInfo,
        lineNumbers=false)

processProject "Docs"
processProject "Interfaces"
