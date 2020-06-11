namespace BlowingUpFoq.Specs
open System
open Foq
open FsUnit
open NUnit.Framework
open Simple.Web
open Accounts
open UserData

module ``LoginPost Specs`` =
    open Simple.Web.Behaviors
    open Accounts.Login

    let createHandler (service: Mock<IUserService>) =
        LoginPost(service.Create()) :> IPost<LoginModel>

    // This is the offending test
    [<Test>]
    let ``given the correct email address and password``() =
        let input = { Email = "me@you.com"; Password = "1Password" }
        let id = Guid.NewGuid()
        let result = id |> Authenticated
        let handler = Mock<IUserService>()
                        .Setup(fun s -> <@ s.AuthenticateUser "me@you.com" "1Password" @>)
                        .Returns<AuthenticationResult>(fun() -> id |> Authenticated) // Should be returning an AuthenticationResult option
                    |> createHandler

        let result = handler.Post input

        result |> should equal (Status 200)
        let user = (handler :?> ILogin).LoggedInUser
        user.Guid |> should equal id
        user.Name |> should equal input.Email


    // Extra tests to show that once the one above dies, these will never be run
    // The entire NUnit test runner just quits with the following error in the Output window:
    //
    // The active Test Run was aborted because the execution process exited unexpectedly.
    // To investigate further, enable local crash dumps either at the machine level or for
    // process vstest.executionengine.x86.exe. Go to more details: http://go.microsoft.com/fwlink/?linkid=232477


    [<Test>]
    let ``given 1 and 1``() =
        let add x y = x + y
        let add1 = add 1

        let result = 1 |> add1

        result |> should equal 2

    [<Test>]
    let ``given 2 and 1``() =
        let add x y = x + y
        let add2 = add 2
        
        let result = 1 |> add2

        result |> should equal 3