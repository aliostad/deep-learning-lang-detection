module ProcessFunctions

open System
open System.Text
open System.IO
open System.Collections.Generic

let exec processName args =
    let psi = new System.Diagnostics.ProcessStartInfo(processName)
    psi.Arguments <- args
    psi.UseShellExecute <- false
    let p = System.Diagnostics.Process.Start(psi)
    p.WaitForExit()

let loadResult fileName = 
    let file = FileInfo(fileName)
    let sr = new StreamReader (fileName, System.Text.Encoding.UTF8)
    let line = sr.ReadLine()
    sr.Dispose()
    if File.Exists(fileName) then
        File.Delete(fileName)
    line

let execMyStem pathToMyStem (word : string) =
    let inputFilePath = "temporaryInputFile.txt"
    
    if File.Exists(inputFilePath) then
        File.Delete(inputFilePath)

    let inputFile = File.CreateText(inputFilePath)
    inputFile.Write(word)
    inputFile.Dispose()

    let outputFilePath = "temporaryOutputFile.txt"
    exec pathToMyStem (inputFilePath + " " + outputFilePath)
    loadResult outputFilePath