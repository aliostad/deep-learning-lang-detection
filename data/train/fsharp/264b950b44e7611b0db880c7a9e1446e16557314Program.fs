namespace HouseholdManager.Api

module Program =
    
    open System.Net
    
    open Suave
    open Suave.Filters
    open Suave.Operators


    [<EntryPoint>]
    let main argv =
        let app = 
            choose [
                GET >=> choose [
                    path "/" >=> (Successful.OK "FOO")
                    path "/api/shopping-list" >=> Api.ShoppingList.listWebpart
                ]
                POST >=> choose [
                    path "/auth/login" >=> context Api.Auth.login
                ]
            ]

        let config = {
            defaultConfig with 
                bindings = [HttpBinding.create HTTP IPAddress.Any 8090us]
        }
        startWebServer config app
        0