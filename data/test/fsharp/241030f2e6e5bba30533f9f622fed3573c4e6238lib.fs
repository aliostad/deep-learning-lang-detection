[<AutoOpen>]
module GraphIt.Lib

open System
open System.IO

module Array = 
  let count x = Array.length x

module String = 
  let replace (s:string) (r:string) (x:string) = x.Replace(s,r)

module File =
  let toFile file text =
    let file = File.CreateText(file)
    file.Write(text : string)
    file.Close()

module Process =
  let start proc args =
    System.Diagnostics.Process.Start(proc,args) |> ignore
  let start1 (proc:string) =
    System.Diagnostics.Process.Start(proc) |> ignore
