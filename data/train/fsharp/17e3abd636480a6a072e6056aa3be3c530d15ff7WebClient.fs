namespace FunKedex

module WebClient =
    open Newtonsoft.Json
    open System
    open System.Net.Http
    open FunKedex.Domain.Serialization

    let defaultBaseUrl = "http://localhost:8083"

    let getAllPokemonsWithWebserviceUrl baseUrl = async {
        use handler = new HttpClientHandler()
        use httpClient = new HttpClient(handler)
        httpClient.BaseAddress <- new Uri(baseUrl)
        let! result = httpClient.GetStringAsync (new Uri("/api/v1/pokemons")) |> Async.AwaitTask
        let rawPokemons = JsonConvert.DeserializeObject<SerializedPokemon list> (result)
        return rawPokemons |> List.map deserializePokemon
    }

    let getAllPokemons () = getAllPokemonsWithWebserviceUrl defaultBaseUrl
