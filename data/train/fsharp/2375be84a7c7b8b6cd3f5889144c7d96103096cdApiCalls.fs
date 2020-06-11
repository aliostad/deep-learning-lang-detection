module ApiCalls

open FSharp.Data

let apiKey = "66pedstgeyz4wa2uycf5qf3f"

type Film = {id: string;
             title: string}

let trim (s: string) = s.[1..s.Length-2]

let makeFilm (j: JsonValue) =
    {id = j.Item("id").ToString() |> trim;
     title = sprintf "%s (%s)" (j.Item("title").ToString() |> trim) 
                               (j.Item("year").ToString())
    }


let getFilmRecord (json: JsonValue) = 
    match json with
    | JsonValue.Record [|total; movies; _; _ |]
        -> match movies with
            | (_, JsonValue.Array [| movie |])
                -> movie 
                    |> makeFilm
                    |> Some
            | _ -> None
    | _ -> None


let getFilmByTitle title = 

    System.Threading.Thread.Sleep(100)
    Http.RequestString
        ("http://api.rottentomatoes.com/api/public/v1.0/movies.json", 
            httpMethod = "GET",
            query = [ "q", title;
                      "page_limit", "1";
                      "page", "1";
                      "apikey", apiKey] )
        |> JsonValue.Parse
        |> getFilmRecord


let getSimilarFilms id =
   
    System.Threading.Thread.Sleep(100)
    let url =  sprintf "http://api.rottentomatoes.com/api/public/v1.0/movies/%s/similar.json" id
    let json = Http.RequestString
                (url,
                 httpMethod = "GET",
                 query = [ "limit", "5";
                           "apikey", apiKey])
                |> JsonValue.Parse
    
    match json with
    | JsonValue.Record [| movies; _; _|]
        -> match movies with
            | (_, JsonValue.Array a) -> a |> Array.map makeFilm |> Some
            | _ -> None
    | _ -> None
