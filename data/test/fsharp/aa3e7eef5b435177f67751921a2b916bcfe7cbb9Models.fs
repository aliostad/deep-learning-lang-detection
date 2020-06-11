namespace TodoApi.Models

open System
open System.Collections.Concurrent


type TodoItem = { 
    Key : string 
    Name : string
    IsComplete : bool 
}

type TodoRepository = {
  Add : TodoItem -> Option<TodoItem>
  GetAll : unit -> seq<TodoItem>
  Find : string -> Option<TodoItem>
  Remove : string -> Option<TodoItem>
  Update : TodoItem -> Option<TodoItem> 
}


module TodoRepositoryDb =
    let private todos = 
        new ConcurrentDictionary<string, TodoItem>()

    let add todo =
        let copy = { todo with Key = Guid.NewGuid().ToString() }

        if todos.TryAdd( copy.Key, copy )
            then Some( copy )
            else None 

    let getAll (key:unit) = 
        todos.Values
        |> Seq.cast


    let find key =
        let ( success, value ) = todos.TryGetValue( key )

        if success 
            then Some( value )
            else None 


    let remove key =
        let ( success, value ) = todos.TryRemove( key )
        
        if success 
            then Some( value )
            else None


    let update todo =
        let tryupdate current =
            if todos.TryUpdate( todo.Key, todo, current ) 
                then Some( todo )
                else None

        find todo.Key |> Option.bind tryupdate


    let todoRepositoryDb = {
        Add = add
        GetAll = getAll
        Find = find
        Remove = remove
        Update = update
    }