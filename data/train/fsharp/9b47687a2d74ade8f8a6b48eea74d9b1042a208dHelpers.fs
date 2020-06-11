module Helpers

    open System.IO
    open System.Runtime.Serialization
    open Newtonsoft.Json
    open System.Threading.Tasks

    let NextRandom =
        let rndGen = new System.Random(int System.DateTime.Now.Ticks)
        (fun max -> rndGen.Next(max))

    type 'a ``[]`` with
        member a.RandomArrayPermutation() =
            let arrCopy = a.Clone() :?> ('a array)
            let rec aux = function
                | 0 -> arrCopy
                | k -> let i = NextRandom(k+1)
                       let tmp = arrCopy.[i]
                       arrCopy.[i] <- arrCopy.[k]
                       arrCopy.[k] <- tmp
                       aux (k-1)
            aux (Array.length arrCopy - 1)

    let populateFromJson<'a> json (targetObject:'a) =
        try
            JsonConvert.PopulateObject(json, targetObject)
        with | _ -> ()
        targetObject

    let removeAt index input =
        input 
        |> List.mapi (fun i el -> (i <> index, el)) 
        |> List.filter fst |> List.map snd

    type Result<'a> =
      | Success of 'a
      | Failure of string

    let encoding = System.Text.Encoding.UTF8

    [<AutoOpen>]
    module Async =
        let inline awaitPlainTask (task: Task) = 
            // rethrow exception from preceding task if it fauled
            let continuation (t : Task) : unit =
                match t.IsFaulted with
                | true -> raise t.Exception
                | arg -> ()
            task.ContinueWith continuation |> Async.AwaitTask

    module List =
        let removeAt index input =
            input 
            |> List.mapi (fun i el -> (i <> index, el)) 
            |> List.filter fst 
            |> List.map snd