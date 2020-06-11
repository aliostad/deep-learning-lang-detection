module ModelBased

open System
open System.Text

open Xunit
open FsCheck
open FsCheck.Xunit


// The interface
type User = { name : string ; age : int }

type IUserHandler =
    abstract member AddUser : User -> unit
    abstract member GetUser : string -> Option<User>
    abstract member DeleteUser : string -> unit



// Operations against the interface
type Operation =
    | Add of User
    | Get of string
    | Delete of string

let applyOp (op : Operation) (handler : IUserHandler) =
    match op with
    | Add user -> handler.AddUser user
    | Get name -> handler.GetUser name |> ignore
    | Delete name -> handler.DeleteUser name



// this is our "real" implementation
type UserHandler() = 
    let users = System.Collections.Generic.Dictionary<string, User>()

    member this.UserCount = users.Count

    interface IUserHandler with
        
        member this.AddUser u =
            users.[u.name] <- u

        member this.GetUser name =
            match users.TryGetValue name with
            | (true, user) -> Some user
            | _ -> None
            
        member this.DeleteUser name =
            if name <> null && name.Contains "*" // catastrophic bug
            then users.Clear()
            else users.Remove name |> ignore


// this is our model
// the only thing we care about is how many users there are
// so we just store the names as a set
type UserCountModel() =

    let users = System.Collections.Generic.HashSet<string>()

    interface IUserHandler with
       
        member this.AddUser u = 
            users.Add u.name |> ignore

        member this.DeleteUser name =
            users.Remove name |> ignore

        member this.GetUser name = None
        
    member this.Verify (real : UserHandler) =
        Assert.Equal(users.Count, real.UserCount)



[<Property>]
let ``Check implementation against model`` (operations : List<Operation>) =
    let real = UserHandler()
    let model = UserCountModel()

    let applyToBothModels op =
        try
            applyOp op real
            applyOp op model
        with
            // for demo purposes, just ignore errors relating to nulls
            | :? ArgumentNullException -> ()

    List.iter applyToBothModels operations

    model.Verify real