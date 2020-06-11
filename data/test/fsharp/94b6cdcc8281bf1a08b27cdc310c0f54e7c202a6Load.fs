namespace Manage_datasets

open System.IO
open Global_configurations.Data_types
open Global_configurations.Config

module internal Load =
    let dataset filepath = 
        let lines = File.ReadAllLines filepath
        let header = (Array.head lines).Split(',');
        let observations = 
            lines
            |> Array.tail
            |> Array.map (fun s -> s.Split(','))
        { Header = header;
          Observations = observations }

    let feature filepath =
        let lines = File.ReadAllLines filepath
        let name = (Array.head lines)
        let observations =
            lines
            |> Array.tail
            |> Array.Parallel.map (fun obs -> float obs)
        { Name = name; Observations = observations }

    let feature_names (dirpath:string) =
        Directory.GetFiles dirpath
        |> Array.Parallel.map (fun file -> 
            let stream = new StreamReader(file)
            let name = stream.ReadLine ()
            stream.Close ()
            name)
            
    let multiple_features (feature_names:string[]) =
        let file_streamreaders = 
            feature_names
            |> Array.map (fun name -> new StreamReader (Path.Combine(File_directories.Features, name) |> File_extension.csv))

        file_streamreaders |> Array.iter (fun sr -> ignore (sr.ReadLine ()))

        let observations =
            Array.init 
                Data_parameters.Number_of_observations
                (fun _ -> file_streamreaders |> Array.map (fun sr ->  float (sr.ReadLine ())))

        file_streamreaders |> Array.iter (fun sr -> sr.Close ())

        { Header = feature_names; Observations = observations }