module LightBlue 

open System
open System.Collections.Concurrent
open System.Collections.Generic
open System.IO
open System.Net
open System.Text.RegularExpressions
open System.Linq


let rootFolder = @"C:\Users\chris.mckelt\AppData\Local\LightBlue\dev\blob\documents\"

let clean (filename:string) =       let mutable ret = filename
                                    for f in Path.GetInvalidFileNameChars()  do
                                        ret <- ret.Replace(Convert.ToString(f), "")
                                    ret                    

let private copyRename fileToRename =   let xxx= Path.GetFileNameWithoutExtension(fileToRename) 
                                        xxx
                                        |> fun x-> Path.Combine(x, ".pdf")  
                                        |> fun x -> clean(x)
                                        |> fun x-> File.Copy(fileToRename, Path.Combine(rootFolder,x)) 
                                        
let rec private fix  =
    if not <| Directory.Exists rootFolder then 
             failwith "Directory does not exist"
    let fs = Directory.EnumerateFiles(rootFolder)
    fs
    |>  try
            Seq.iter(fun x-> copyRename(x) |> ignore)
        with | ex -> raise ex 
    |> ignore

let run = fix  