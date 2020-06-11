namespace SpinnAPI.Controllers

open System
open System.Collections.Generic
open System.Linq
open System.Web
open System.Web.Mvc
open System.Web.Mvc.Ajax

open SpinnAPI.Models
open SpinnAPI.DataRepository

type HomeController(queries : DataQueries) =
    inherit Controller()
    new () = new HomeController(DataQueries())
    
    member this.Index() = 
        this.View()

    member this.Spinntools() =
        this.Redirect("http://app.spinntools.com/")

    member this.Tokens() =
        use db = DataConnection.GetDataContext()
        
        let users = queries.FindAllUsers(db)
        db.Connection.Close()

        this.ViewData.Add("Users", users)

        this.View()