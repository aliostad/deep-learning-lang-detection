namespace Api.Tests

open Xunit
open FsUnit.Xunit
open System.Web.Http
open System.Net.Http

open Api.Common
open Api.Domain
open Api.Controllers
open Api.Representations

module ``Uses Case Tests`` =
    

    [<Fact>]
    let ``Post returns 'Ok' response on valid data and trusted provider``() =

        let start _ = { Account.Email = "test@email.fr" |> EmailAddress |> VerifiedEmail |> Verified
                        Password = "pass"
                        Provider = "OAuth"
                        Confirmation = None} |> Success

        use controller = new RegisterController(start)
        controller.Request <- new HttpRequestMessage(HttpMethod.Post, "http://localhost/api/register")

        let representation = {Email = "test@email.fr"
                              Password ="pass"
                              Privacy = true
                              Provider ="OAuth"}
        
        let result : IHttpActionResult = controller.Register representation

        result |> should be ofExactType<Results.OkResult>

