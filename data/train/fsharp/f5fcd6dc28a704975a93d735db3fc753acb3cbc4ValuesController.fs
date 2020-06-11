namespace SpinnAPI.Controllers

open System
open System.Collections.Generic
open System.Linq
open System.Net.Http
open System.Web.Http

open SpinnAPI.Models
open SpinnAPI.DataRepository

/// Retrieves values.
type UsersController(queries : DataQueries) =
    inherit ApiController()
    new () = new UsersController(DataQueries())
    
    /// POST /api/users/{UserModel}
    member x.Post([<FromBody>] value:User) = 
        
        use db = DataConnection.GetDataContext()

        let newtoken =                                                            
            let chars = "ABCDEFGHIJKLMNOPQRSTUVWUXYZ0123456789abcdefghijklmnopqrstuvwxyz"
            let charsLen = chars.Length
            let random = System.Random()
            let randomChars = [|for i in 0..24 -> chars.[random.Next(charsLen)]|]
            new String(randomChars)

        let newUser = new DataConnection.ServiceTypes.Users(Name = value.Name, Identifier = newtoken, Email = value.Email)
        
        db.Users.InsertOnSubmit(newUser)
        db.DataContext.SubmitChanges() |> ignore
        
        newtoken

    /// DELETE /api/users/{token}
    member x.Delete(id:string) =
        use db = DataConnection.GetDataContext()

        let user = queries.FindUserByToken(id, db)

        db.Users.DeleteOnSubmit(user)
        db.DataContext.SubmitChanges() |> ignore

    /// GET /api/users
    member x.GetAll() =
        use db = DataConnection.GetDataContext()
        
        let users = queries.FindAllUsers(db)
        db.Connection.Close()

        users

type QSController(queries : DataQueries) =
    inherit ApiController()
    new () = new QSController(DataQueries())

    member x.Post(id:string) = 
        
        use db = DataConnection.GetDataContext()

        let user = queries.FindUserByToken(id, db)

        let newQS = new DataConnection.ServiceTypes.QualityScore(User_Id = user.Id)
        
        db.QualityScore.InsertOnSubmit(newQS)
        db.DataContext.SubmitChanges() |> ignore
        
        200

/// Retrieves values.
[<RoutePrefix("api2/values")>]
type ValuesController() =
    inherit ApiController()
    let values = [|"value1";"value2"|]

    /// Gets all values.
    [<Route("")>]
    member x.Get() = values

    /// Gets the value with index id.
    [<Route("{id:int}")>]
    member x.Get(id) : IHttpActionResult =
        if id > values.Length - 1 then
            x.BadRequest() :> _
        else x.Ok(values.[id]) :> _