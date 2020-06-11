#I "../lib/net40"
#load "literate.fsx"
open FSharp.Literate

let processDirectory () =
    let path     = __SOURCE_DIRECTORY__
    let dir      = path + @"..\..\..\..\DocSample"
    let template = path + @"\templates\template-project.html"
    let projectInfo =
        [ "page-description", "My Sample Document"
          "page-author", "Nobuhisa"
          "github-link", "https://github.com/Nobuhisa"
          "project-name", "DocSample" ]

    Literate.ProcessDirectory(dir, template,
        outputDirectory = dir + "\\docs", replacements = projectInfo)

do
    printfn "Start..."
    processDirectory ()
    printfn "finish!"

    #if INTERACTIVE
    #else
    System.Console.ReadKey() |> ignore
    #endif