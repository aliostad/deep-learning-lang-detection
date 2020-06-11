module Solution
(*
For some reason, Deli’s love using excel sheets! They want us to consume json sent by their undocumented api and convert the data into a csv file.
- Consumes json from a mocked endpoint
- Prints all fields of each item in a csv format

Sample Json
{
  "Users" : [
    { "UserId" : "42", "Name" : "Jeremy", "FavoriteDeliItem" : "Relative" }
  ]
}
*)
open FSharp.Data

type UsersFromApi = JsonProvider<""" 
  {
    "Users" : [
                { "UserId" : 42, "Name" : "Jeremy", "FavoriteDeliItem" : "Relative" }
              ]
  }
  """
  >

let printHeader () =
  printfn "UserId,Name,FavoriteDeliItem"

let printUser (user : UsersFromApi.User) =
  printfn "%i,%s,%s" user.UserId user.Name user.FavoriteDeliItem

let dataFromApi = MockDAL.getUsers()

let parsedData = dataFromApi |> UsersFromApi.Parse

printHeader ()
parsedData.Users |> Array.iter printUser

