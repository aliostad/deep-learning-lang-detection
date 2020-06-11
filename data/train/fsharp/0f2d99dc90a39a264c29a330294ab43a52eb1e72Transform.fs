namespace Manage_datasets

open Global_configurations.Data_types

module internal Transform =
    let group_by_feature (dataset:Dataset<float>) feature_name =
        let feature_index = dataset.Header |> Array.findIndex (fun name -> name = feature_name)
        let header = dataset.Header

        dataset.Observations
        |> Array.groupBy (fun obs -> obs.[feature_index])
        |> Array.Parallel.map (fun (feature_value, data) -> 
            (feature_value, 
                { Header = header;
                  Observations = data }))
        

