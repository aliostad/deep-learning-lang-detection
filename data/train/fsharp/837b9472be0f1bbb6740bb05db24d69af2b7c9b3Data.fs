module FSharpMeetupXamarinForms.Data

open System
open System.Collections.Generic
open FSharp.Data

// http://fsharp.github.io/FSharp.Data/

[<Literal>]
let baseApiUrl = "http://pokeapi.co/api/v2/"

[<Literal>]
let listUrl = baseApiUrl + "pokemon"

[<Literal>]
let pokemonDetailSampleUrl = baseApiUrl + "pokemon/1" //bulbasaur

type PokemonListApi = JsonProvider<listUrl, RootName="PokemonListSummary">
type PokemonSummary = {Name: string; Url: string}
type PokemonDetailApi = JsonProvider<pokemonDetailSampleUrl, RootName="PokemonDetail">
type PokemonDetail = {Name: string; ImgUrl: string}

let getPokemon () : PokemonSummary [] =
  let pl = PokemonListApi.Load(listUrl)
  pl.Results
  |> Array.map(fun p -> {Name = p.Name; Url = p.Url })

let getPokemonDetail (url : string) : PokemonDetail =
    let pd = PokemonDetailApi.Load(url)
    { Name = pd.Name; ImgUrl = pd.Sprites.FrontDefault }

let getPokemonDetailAsync (url :string) = async {
    let! pd = PokemonDetailApi.AsyncLoad(url)
    return { Name = pd.Name; ImgUrl = pd.Sprites.FrontDefault }
}