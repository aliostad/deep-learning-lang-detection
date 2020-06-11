open System.IO

let reverse (data: byte[]) =
    Array.rev data

let asyncProcessFile (filePath: string) (processBytes: byte[] -> byte[]) =
    async {
        let fileName = Path.GetFileName(filePath)
        printfn "Processing file [%s]" fileName
        use fileStream = new FileStream(filePath, FileMode.Open)
        let bytesToRead = int fileStream.Length
        let! data = fileStream.AsyncRead(bytesToRead)
        printfn "Opened [%s], read [%d] bytes" fileName data.Length
        let data' = processBytes data
        use resultFile = new FileStream(filePath + ".results", FileMode.Create)
        do! resultFile.AsyncWrite(data', 0, data'.Length)
        printfn "Finished processing file [%s]" <| fileName
    } |> Async.Start