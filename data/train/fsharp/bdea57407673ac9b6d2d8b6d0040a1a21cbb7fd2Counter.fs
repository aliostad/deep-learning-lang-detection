module Counter

open Elmish

// Model
type Model =
  {count:int }

let init() =
  failwith "TODO: implement me"

// Update
type Msg =
  | Increment
  | Decrement

let update msg model =
  match msg with
  | Increment -> 
    failwith "TODO: implement me"
  | Decrement -> 
    failwith "TODO: implement me"

// View
module R = Fable.Helpers.ReactNative

let view model (dispatch:Dispatch<Msg>) =
  let onClick msg =
    fun _ -> msg |> dispatch
  // Hint: copy from the counter sample
  failwith "TODO: implement me"

