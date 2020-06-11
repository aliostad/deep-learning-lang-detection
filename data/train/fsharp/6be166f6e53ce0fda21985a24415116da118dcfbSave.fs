namespace Manage_datasets

open Global_configurations.Data_types
open System.IO
open System

module internal Save =
    let private writable filepath data_type =
        match File.Exists filepath with
        | true -> 
            let mutable decided = false
            let mutable decision = false
            while not decided do
                printfn "The given %s already exists. Overwrite? (y/n)" data_type
                let pot_decision = Console.ReadLine ()
                match pot_decision with
                | "y" -> decision <- true; decided <- true
                | "n" -> decision <- false; decided <- true
                | _ -> decided <- false
            decision
        | false -> true

    let dataset (data:Dataset<'a>) filepath =
        match writable filepath "dataset" with
        | true ->
            let header = data.Header |> String.concat ","
            let observations = 
                data.Observations
                     |> Array.map (fun obs -> 
                        obs
                        |> Array.map (fun x -> x.ToString ())
                        |> String.concat ",")
                     |> String.concat "\n"
            File.WriteAllText(
                filepath,
                sprintf "%s\n%s" header observations)
        | false -> ()

    let feature (feature:Feature<'a>) filepath =
        match writable filepath "feature" with
        | true ->
            let name = [|feature.Name|]
            let observations = feature.Observations |> Array.map (fun obs -> obs.ToString())
            File.WriteAllText(
                filepath,
                Array.append name observations
                |> String.concat "\n")
        | false -> ()
