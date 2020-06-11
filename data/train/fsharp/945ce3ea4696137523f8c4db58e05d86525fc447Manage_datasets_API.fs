namespace Manage_datasets

open Global_configurations.Config
open Global_configurations.Data_types
open System.IO
open Featurizers

module Manage_datasets_API =
    let Generate_initial_dataset () =
        let dataset = 
            File_paths.Raw_trainig_set
            |> Load.dataset 
            |> Parse.string_dataset

        Save.dataset dataset File_paths.Initial_dataset
    
    let Initial_dataset = 
        File_paths.Initial_dataset
        |> Load.dataset
        |> fun { Header = header; Observations = obs } -> 
            { Header = header; 
              Observations = obs |> Array.Parallel.map (Array.map float) }

    let Generate_features () =
        let index_of = Initial_dataset.Header |> Array.mapi (fun i name -> (name, i)) |> Map.ofArray
        let transformation = Feature_production.Transformation index_of
        let features = Manage_features.split_dataset_to_features Initial_dataset transformation Feature_production.Header

        features
        |> Array.Parallel.iter (fun feature ->
            let filepath = Path.Combine(File_directories.Features, feature.Name) |> File_extension.csv
            Save.feature feature filepath)


    let Load_feature_set (feature_names:string[]) = Load.multiple_features feature_names

    let Load_feature feature_name = 
        let filepath = Path.Combine(File_directories.Features, feature_name) |> File_extension.csv
        Load.feature filepath

    let Get_available_feature_names () = Load.feature_names File_directories.Features

    let Save_feature (feature:Feature<float>) = 
        let filepath = Path.Combine(File_directories.Features, feature.Name) |> File_extension.csv
        Save.feature feature filepath

    let Group_by_feature dataset feature_name = Transform.group_by_feature dataset feature_name 