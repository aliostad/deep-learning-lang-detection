open Suave
open Suave.Filters
open Suave.Operators
open Suave.Successful
open FunKedex.WebAPI

type Dependency = {
    loadPokemonsAsync : FunKedex.Domain.Pokemons.LoadPokemonsAsync
}

let DI = {
    loadPokemonsAsync = FunKedex.MySql.Pokemons.loadPokemonsAsync // wanna use mocks instead ? -> FunKedex.Domain.Pokemocks.getFakePokemonsAsync
}

let app =
    choose 
        [ GET >=> choose 
            [ path "/" >=> OK "Up and running ! Just call <pre>/api/v1/pokemons</pre> to retrieve pokemons !"
              path "/api/v1/pokemons" >=> PokemonsAPI.getPokemons DI.loadPokemonsAsync
            ] 
        ]

[<EntryPoint>]
let main argv = 
    startWebServer defaultConfig app
    0
