namespace BookMate

module Program = 
    open System.IO
    open BookMate.Processing
    open BookMate.Core

    let rec getBookPath = 
        function
        | [||] | [| "" |] | [| null |] -> 
            printf @"Please type in the file path (w/o """"): "
            let bookPath = System.Console.ReadLine()
            if File.Exists bookPath then bookPath
            else 
                printfn "Sorry, file does not exist."
                getBookPath [| "" |]
        | [| bookPath |] -> 
            if File.Exists bookPath then bookPath
            else 
                printfn "Sorry, file does not exist."
                getBookPath [| "" |]
        | _ -> failwith "Sorry. Can't hand these input arguments."
    
    // let chooseBookProcessor (path : string) = 
    //     match Path.GetExtension path with
    //     | ".epub" -> EpubProcessor.processBook
    //     | _ -> failwith "Format isn't supported"
    
    [<EntryPoint>]
    let main argv = 
        //let bookPath = getBookPath <| argv
        //let processBook = chooseBookProcessor bookPath 
        //do processBook bookPath

        System.Console.Read() |> ignore
        0
