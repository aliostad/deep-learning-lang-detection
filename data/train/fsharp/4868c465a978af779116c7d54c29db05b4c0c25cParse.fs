namespace Impossible

module Parse =

    open FSharpx.Control

    type APIParse =
        | APIList of API.APIList
        | AllFilmLists
        | AllActorLists
        | AllActors
        | AllFilms

    let rec generateAPI api version conn : Async<string * API.APIList> list =
        match api with
        | APIList x ->
            match x with
            | API.Films (pageNumber, _) ->
                [ DB.getMovieList pageNumber version conn ]
            | API.Actors pageNumber -> failwith "Actors not yet implemented"
            | API.Actor id -> failwith "Actor not yet implemented"
            | API.Film id -> failwith "Film not yet implemented"
        | AllFilmLists ->
            let count = DB.getMovieListPageCount conn
            {1..count}
            |> Seq.collect (fun pageNumber -> generateAPI (APIList(API.Films(pageNumber, Some version))) version conn)
            |> Seq.toList
        | AllActorLists -> failwith "AllActorLists not yet implemented" 
        | AllActors -> failwith "AllActors not yet implemented"
        | AllFilms -> failwith "AllFilms not yet implemented"

//    let temp conn =
//            DB.getMovieListPageCount(conn)
//            |> Async.map (fun count -> 
//                [1 .. count]
//                |> List.map (fun pageNumber -> generateAPI (APIList <| API.Films(pageNumber, API.V1P0)) [|API.V1P0|] conn)
//            )

