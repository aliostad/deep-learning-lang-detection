namespace PasteBinParser

open System.Text
open System.IO
open System.Net
open FSharp.Net
open FSharp.Data
open System.Xml.Linq
open System.IO

module Parser =

    type PasteProvider = XmlProvider<"samplePaste">
    type Paste = PasteProvider.DomainTypes.Paste

    [<EntryPoint>]
    let main(args) = 

        if args.Length <> 2 then 
            
            printfn "Usage: PasteBinParser <apiKey> <output filename>"
            
        else

            let url = "http://pastebin.com/api/api_post.php"
            let apiKey = args.[0]
            let outFile = args.[1]

            let options = "api_option=trends&api_dev_key=" + apiKey
    
            let result = Http.Request("http://pastebin.com/api/api_post.php", body = options  )

            let parsedResult = PasteProvider.Parse("<root>" + result + "</root>")
        
            let result = parsedResult.GetPastes()

            let titles = Array.map (fun (x:Paste) -> x.PasteTitle) result
            let pasteKeys = Array.map (fun (x:Paste) -> x.PasteKey) result

            let pastes = Array.map (fun x -> Http.Request("http://pastebin.com/raw.php?i=" + x)) pasteKeys

            let outFile = new StreamWriter(outFile)
            
            pastes |> Array.iter (fun x -> outFile.WriteLine(x))

        0