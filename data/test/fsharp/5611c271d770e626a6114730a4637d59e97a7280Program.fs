module Program
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
open MockAPI

type private DeliJsonFromApi = JsonProvider<"""
  {
    "Users" : [
      { "UserId" : "42", "Name" : "Jeremy", "FavoriteDeliItem" : "Relative" }
    ]
  }"""
  >

let dataFromApi = 
  let data = MockAPI.getUsers ()
  DeliJsonFromApi.Parse data

let printCsvToConsole ( data : DeliJsonFromApi.Root) =
  let printHeaders () =
    printfn "UserId, Name, FavoriteDeliItem"
  
  printHeaders ()

  let printUserCsv ( user : DeliJsonFromApi.User ) =
    printfn "%i, %s, %s " user.UserId user.Name user.FavoriteDeliItem

  data.Users
  |> Array.iter printUserCsv

dataFromApi
|> printCsvToConsole


 