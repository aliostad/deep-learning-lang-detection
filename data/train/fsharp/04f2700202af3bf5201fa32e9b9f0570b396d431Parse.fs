namespace Manage_datasets

open Global_configurations.Data_types
open System

type Observation = Float | Date

module internal Parse = 
    let tryParseDate str =
            let mutable dt = DateTime.MaxValue
            let potential_date = DateTime.TryParse(str, ref dt)
            match potential_date with
            | true -> Some (DateTime.Parse str)
            | false -> None

    let  tryParseDouble (str:string) = 
            let stripped_str = str.Replace ("\"", "")
            let mutable db = 0.0
            let potential_double = Double.TryParse(stripped_str, ref db)
            match potential_double with
            | true -> Some (Double.Parse stripped_str)
            | false -> None

    let string_dataset (data:Dataset<string>) = // TODO Make function more readable
        let type_recognition_lines = 
            data.Observations 
            |> Array.take (Math.Min (500000, data.Observations.Length)) // TODO: Let the user customize the type of features

        let split_header = 
            match type_recognition_lines.Length > 0 with 
            | true -> 
                data.Header
                |> Array.mapi (fun ind _ -> 
                    let feature_vector = type_recognition_lines |> Array.map (fun obs -> obs.[ind])
                    let data_header = data.Header.[ind].Replace ("\"", "")
                    let is_date fvec = (fvec |> Array.head |> tryParseDate).IsSome
                    let is_float fvec = not (fvec |> Array.exists (fun elem -> (tryParseDouble elem).IsNone)) 
                    let different_values (fvec:string[]) = 
                        fvec 
                        |> Array.map (fun elem -> elem.Replace ("\"", ""))
                        |> Array.distinct 

                    match (is_date feature_vector, is_float feature_vector) with 
                    | true, _ -> [|data_header, "year"; data_header, "month"; data_header, "day"|]
                    | _, true -> [|data_header, ""|]
                    | _ -> different_values feature_vector |> Array.map (fun elem -> data_header, elem))
            | false -> failwith "Empty feature set"

        let header = 
            split_header 
            |> Array.collect id 
            |> Array.map (fun (a, b) -> 
               match b with 
               | "" -> a
               | _ -> a + "_" + b)

        let parse_observation obs= 
            obs
            |> Array.mapi (fun ind elem -> 
                let header_length = split_header.[ind].Length
                match tryParseDate elem, header_length with
                | Some(date), _ -> [|float date.Year; float date.Month; float date.Day|]
                | _, 1 -> [|(tryParseDouble elem).Value|]
                | _, _ ->
                    Array.init 
                        header_length
                        (fun pos ->
                            match snd split_header.[ind].[pos] = elem.Replace ("\"", "") with 
                            | true -> 1.0 
                            | false -> 0.0))
            |> Array.collect id

        let observations = 
            data.Observations
            |> Array.map parse_observation

        { Header = header; Observations = observations}

