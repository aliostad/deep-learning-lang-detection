namespace HouseholdManager.Api

module Api = 
    open Suave
    open Suave.RequestErrors
    open HouseholdManager.Core.Domain

    type ApiError = 
        | UtilsError of string
        | DomError of  DomainError
    
    module Utils =
        open Suave.Successful
        open Suave.Operators
        open Newtonsoft.Json
        open Newtonsoft.Json.Serialization

        let toJson v =
            let s = JsonSerializerSettings()
            s.ContractResolver <- CamelCasePropertyNamesContractResolver()

            JsonConvert.SerializeObject(v, s)
            |> OK
            >=> Writers.setMimeType "application/json; charset=utf-8"

        let private getString = System.Text.Encoding.UTF8.GetString
        let fromJson<'a> req =
            let fromJson json =
                try 
                    JsonConvert.DeserializeObject(json, typeof<'a>) 
                    :?> 'a
                    |> Ok
                with
                | _ -> Error  "Cannot deserialize request"
            
            req.rawForm |> getString |> fromJson

    module ShoppingList =
        open System
        type Item = {
            Id: Guid
            Name: string
            Count: int
        }

        let list = [{Id = Guid.NewGuid(); Name = "Foo"; Count = 10}]

        let listWebpart =
            list |> Utils.toJson

    module Auth =
        open HouseholdManager.Core.Domain.User

        let login ctx = 
            let (>>=) r f = Result.bind f r
            let (<!>) v f = Result.map f v

            let translateErr = function
            | DomError err -> 
                match err with 
                | UserError e -> "USER ERROR"
            | UtilsError err ->
                "UTILS ERROR"


            let toWebpart handler res =
                match res with 
                | Ok ev -> handler ev
                | Error err -> BAD_REQUEST (translateErr err)

            let eventHandler = function
                | LoggedIn u ->
                    Utils.toJson u
                | LoggedOut ->
                    Suave.Successful.OK ""

            let test = toWebpart eventHandler
            
            Utils.fromJson<LoginRequest> ctx.request 
                |> Result.mapError ApiError.UtilsError 
                <!> Login  
                >>= (commandHandler >> Result.mapError ApiError.DomError)
                |> test 
            