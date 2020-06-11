module index

open Fable.Core
open Fable.Import
open Fable.Core.JsInterop

let app = express.Invoke()

type Request = express.Request
type Response = express.Response

let inline toHandler (fn : Request -> Response -> (obj -> unit) -> obj) : express.RequestHandler =
    System.Func<_,_,_,_>(fn)

type TodoItem = {
    id : int
    description : string
    completed : bool
}

type AddTodoItemDto = {
    description : string
    completed : bool
}

let [<Import("*", "body-parser")>] bodyParser = obj()

app.``use``(bodyParser?json$() |> unbox<express.RequestHandler>) 
|> ignore

app.``use``(toHandler <| fun _ res next ->
    res.header("Access-Control-Allow-Origin", "*") |> ignore
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept") |> ignore
    res.header("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS") |> ignore
    next()
    obj()
    ) 
|> ignore

let mutable state = Map.empty<int, TodoItem>

app.get
    (   U2.Case1 "/", 
        toHandler <| fun _ res _ -> 
            res.send("Hello world") |> box
    ) |> ignore

app.route("/todo")
    .post(toHandler <| fun req res _ ->
         let dto = unbox<AddTodoItemDto> req.body
         let newId = 
            state
            |> Map.fold (fun s key _ -> if key > s then key else s) 0
            |> (+) 1
         let item = { id = newId; description = dto.description; completed = dto.completed }
         state <- Map.add newId item state
         res.status(float 201).send(toJson item) |> box
    )
    .get(toHandler <| fun req res _ ->
        let items = state |> Map.toList |> List.map snd |> List.toArray
        res.send(toJson items) |> box
    )
|> ignore

app.route("/todo/:id")
    .get(toHandler <| fun req res _ ->
        let id = req.``params``?id |> unbox<int>
        if Map.containsKey id state then
            state |> Map.find id |> toJson |> res.send |> box
        else
            res.sendStatus(float 404) |> box
    )
    .delete(toHandler <| fun req res _ ->
        let id = req.``params``?id |> unbox<int>
        state <- Map.remove id state
        res.sendStatus(float 204) |> box
    )
    .put(toHandler <| fun req res _ ->
        let id = req.``params``?id |> unbox<int>
        if Map.containsKey id state then
            let dto = unbox<TodoItem> req.body
            let item = { dto with id = id }
            state <- Map.add id item state
            res.send(toJson item) |> box
        else
            res.sendStatus(float 404) |> box
    )
|> ignore

let port =
    match unbox Node.``process``.env?PORT with
    | Some x -> x
    | None -> 3000

app.listen(port, unbox (fun () -> printfn "Server started at: http://localhost:%i" port)) |> ignore
