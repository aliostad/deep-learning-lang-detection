module MusicUnpacker

open Types
open System.IO

[<EntryPoint>]
let main argv =
    // let r = Archives.getMp3ArchivesInDirectory "C:/Test"

    // let printResult r = printfn "%A" r
    // Seq.iter printResult r
    //let test1 = Archives.getMp3ArchivesInDirectory "C:/Test"
    //let test2 = FilePlacer.processZipExtractionSets "C:/TestOut"
    let outDir = DirectoryInfo("Z:\\music")

    let f = function
        | Success z -> 
            FilePlacer.processZipExtractionSet outDir z
            |> Seq.toList
        | Error e -> [Error e]

    let results = Archives.getMp3ArchivesInDirectory "C:\\Users\\max\\Downloads" 
                  |> Seq.collect f
    Seq.iter (fun x -> printfn "%A" x) results
    0 // return an integer exit code
