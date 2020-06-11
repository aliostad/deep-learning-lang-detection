namespace Manage_datasets

open Global_configurations.Data_types

module internal Manage_features =
    let split_dataset_to_features (dataset:Dataset<'a>) (transformation:'a[] -> 'a[]) header =
        let new_observations = dataset.Observations |> Array.Parallel.map transformation
        let dataset_with_new_features =
            { Header = header;
              Observations = new_observations }

        Array.Parallel.init
            header.Length
            (fun ind -> 
                { Name = header.[ind];
                  Observations = dataset_with_new_features.Observations |> Array.map (fun obs -> obs.[ind])})