module PdfUtils

open System
open System.IO
open System.Diagnostics
open Suave  
open Suave.Filters  
open Suave.Operators  
open Suave.Successful

let pathSeparator = Path.DirectorySeparatorChar.ToString()
let appDir = Directory.GetCurrentDirectory() + pathSeparator
let pdfInputDir = appDir + "pdfInput" + pathSeparator
let textOutputDir = appDir + "textOutput" + pathSeparator
let pdfBoxDir = appDir + "pdfBox" + pathSeparator

let createAppDirs() =
    [pdfInputDir;textOutputDir;]
    |> Seq.iter(fun x -> if not (Directory.Exists x) then Directory.CreateDirectory(x) |> ignore)

let private quoteStr stringValue =
    let quoteChar = @""""
    quoteChar + stringValue + quoteChar

let private extractPdfText pdfFile =
    try
        let pdfFileName = Path.GetFileName pdfFile
        let inputFile = pdfInputDir + pdfFileName
        let javaProcess = new Process()
        javaProcess.StartInfo.FileName <- "java"
        javaProcess.StartInfo.Arguments <- "-jar " 
            + pdfBoxDir + "pdfbox-app-2.0.6.jar ExtractText " 
            + quoteStr(inputFile) + " "
            + quoteStr(textOutputDir + pdfFileName + ".txt")
        javaProcess.Start() |> ignore
        javaProcess.WaitForExit()

        // Delete file after processing.
        File.Delete(inputFile)
     with
        | ex -> printfn "%A" ex
    
let private extractPdfTextAgent = MailboxProcessor.Start(fun inbox ->
    let rec messageLoop() = async {
        let! msg = inbox.Receive()
        extractPdfText msg
        return! messageLoop()
    }
    messageLoop()
)

let processExistingPdfFiles() =
    Directory.GetFiles pdfInputDir
    |> Seq.iter extractPdfTextAgent.Post

let extractText ctx = async {
    let guidAndFiles = ctx.request.files 
                        |> Seq.map(fun x -> (Guid.NewGuid().ToString(), x))
                        |> Seq.toArray

    guidAndFiles
    |> Seq.iter(fun (fileGuid, x) -> 
        let tempFileName = Path.GetFileName x.tempFilePath
        let fileToProcess = pdfInputDir + fileGuid
        File.Copy(x.tempFilePath, pdfInputDir + tempFileName)
        File.Move(pdfInputDir + tempFileName, fileToProcess)
        
        extractPdfTextAgent.Post fileToProcess
    )

    let guidsOnly = guidAndFiles 
                    |> Seq.map(fun (fileGuid, x) -> fileGuid)
                    |> Seq.fold(fun acc x -> if (String.IsNullOrEmpty acc) then x else acc + "," + x) ""
    return! Successful.OK (guidsOnly.ToString()) ctx
}

let getFileText fileName ctx = async {
    let outputFile = textOutputDir + fileName + ".txt"
    if File.Exists outputFile then
        let fileText = File.ReadAllText outputFile
        return! OK fileText ctx
    else
        return! RequestErrors.NOT_FOUND "File not found" ctx
}