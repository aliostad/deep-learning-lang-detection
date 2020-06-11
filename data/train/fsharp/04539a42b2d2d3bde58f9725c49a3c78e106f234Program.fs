open FileCopy
open FileAccess
open FileMatcher
open Enumerator

[<Literal>]
let ``Help Message`` = 
    "I see you are new here :). Here is how you use the command:
CopyFiles <input folder> <output folder> <number files>

Example:

CopyFiles ./ ./CopiedFiles 1,2,5,10..20" 

[<EntryPoint>]
let main args = 
    match args with
    | [|inputDir; outputDir; numbers|] -> 
        inputDir 
        |> allFiles
        |> List.ofSeq
        |> matchingFiles (enumerate numbers)
        |> copyFile outputDir
    | _ -> printfn "%s" ``Help Message``
    0 // return an integer exit code
