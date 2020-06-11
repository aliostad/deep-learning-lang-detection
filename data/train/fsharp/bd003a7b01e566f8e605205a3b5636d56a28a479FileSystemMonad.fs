namespace FsIntegrator

open System.IO
open FSharp.Core
open FSharp.Quotations


type FSCommand =
    |   Move      of string * string
    |   Rename    of string * string
    |   Copy      of string * string
    |   Delete    of string
    |   CreateDir of string
    |   DeleteDir of string
    |   MoveDir   of string * string


type FSScript = {
        CommandList : FSCommand list
    }
    with
        member this.Add item = { this with CommandList = this.CommandList @ [item]}
        static member internal Empty = { CommandList = []}
        static member internal Run (fs:FSScript) =
            let processCommand = 
                function
                |   Move(source, target)    -> File.Move(source, target)
                |   Rename(source, target)  -> File.Move(source, target)
                |   Copy(source, target)    -> File.Copy(source, target)
                |   Delete(target)          -> File.Delete(target)
                |   CreateDir(target)       -> Directory.CreateDirectory(target) |> ignore
                |   DeleteDir(target)       -> Directory.Delete(target)
                |   MoveDir(source, target) -> Directory.Move(source, target)
            fs.CommandList
            |> List.iter(processCommand)


type FSBuilder() = 
    member this.Yield item = FSScript.Empty

    member this.Move((fs:FSScript), (source:string), (target:string)) =
        fs.Add(Move(source, target))

    member this.Rename((fs:FSScript), (source:string), (target:string)) =
        fs.Add(Rename(source, target))

    member this.Copy((fs:FSScript), (source:string), (target:string)) =
        fs.Add(Copy(source, target))

    member this.Delete((fs:FSScript), (target:string)) =
        fs.Add(Delete(target))

    member this.MakeDir((fs:FSScript), target) =
        fs.Add(CreateDir(target))

    member this.RemoveDir((fs:FSScript), target) =
        fs.Add(DeleteDir(target))

    member this.MoveDir((fs:FSScript), source, target) =
        fs.Add(MoveDir(source, target))

