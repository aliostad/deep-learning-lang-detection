namespace FunKedex.Domain

module Pokemocks =
    open Pokemons

    let private pikachu = {
        id = 25
        name = "pikachu"
        height = 40
        weight = 6
        spriteUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"
        types = [ PokemonType "electrik" ]
    }

    let private mewtwo = {
        id = 150
        name = "mewtwo"
        height = 200
        weight = 122
        spriteUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/150.png"
        types = [ PokemonType "psy" ]
    }

    let private mew = {
        id = 151
        name = "mew"
        height = 40
        weight = 4
        spriteUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/151.png"
        types = [ PokemonType "psy" ]
    }

    let getFakePokemonsAsync () = async {
        return [ pikachu; mewtwo; mew ]
    }
