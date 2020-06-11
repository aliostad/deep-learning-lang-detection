module FSharpFormattingCLI

open FSharp.Literate

[<EntryPoint>]
let main argv =
    let template =
        (System.Reflection.Assembly.GetEntryAssembly().Location
        |> System.IO.Path.GetDirectoryName) + "/template.html"

    if argv.Length = 2 then
        if argv.[0].EndsWith ".md" then
            Literate.ProcessMarkdown(argv.[0],template, output = argv.[1])
            0
        elif argv.[0].EndsWith ".fsx" then
            Literate.ProcessScriptFile(argv.[0], template, output = argv.[1])
            0
        else
            -1
    else
        -1
