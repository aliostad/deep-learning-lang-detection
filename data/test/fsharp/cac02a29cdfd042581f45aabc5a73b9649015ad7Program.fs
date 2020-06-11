module Program 

open System
open Google.Cloud.Vision.V1
open TestData
open ProcessDocket
open OCR

let getFromGoogle fileName =    
    let image = Image.FromFile(sprintf "%s.jpg" fileName);
    //File.WriteAllLines(sprintf @"e:\%s.txt" fileName, [|for a in document do yield sprintf "{Description = \"%s\"; Verticies = %s};" a.Description (printVerticies a)|]);
    processImage image

[<EntryPoint>]
let main argv =
    let result = getFromGoogle "docket3"
    //let result = getDocket3
    

    match result with 
    | [] -> Console.WriteLine("No data found")
    | compiledList::annos ->
                            let lines = processDocketData compiledList annos
                            for line in lines do printfn "%s %s" line.Text (if line.Price.IsSome then line.Price.Value.Description else String.Empty)
                            ()

    Console.Read() |> ignore
    0 // return an integer exit code