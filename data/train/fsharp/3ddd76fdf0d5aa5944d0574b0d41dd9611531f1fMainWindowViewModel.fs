namespace RottenTomatoesApi.ViewModel

open System
open System.Collections.ObjectModel
open System.Windows
open System.Diagnostics
open System.Windows.Data
open System.Windows.Input
open System.ComponentModel
open RottenTomatoesApi
open RottenTomatoesApi.Models

type DataSources = MoviesBoxOffice | MoviesInTheater | MoviesOpening | MoviesUpcoming

type MainWindowViewModel() = 
    inherit ViewModelBase()
    
    let movies = 
        //let m = Api.Movies.GetBoxOffice() // |> Seq.iter(fun a -> a.)
       
        let m = Api.Typed.Movies.GetBoxOffice()
        //m |> Seq.iter(fun m -> Debug.WriteLine m.CriticsConsensus)
        m

    member x.Movies = movies

    
