namespace Fooble.UnitTest

open Fooble.Common
open Fooble.Core
open Fooble.Persistence
open Fooble.Presentation
open MediatR
open Moq
open Moq.FSharp.Extensions
open NUnit.Framework
open Swensen.Unquote
open System

[<TestFixture>]
module MemberUsernameQueryTests =

    type private Result =
        | Success of Guid * string
        | NotFound of Guid

    let private setupForHandlerTest result =
        let (id, memberData) =
            match result with
            | Success(id, username) ->
                  makeMemberData (Some(id)) (Some(username)) None None None None None None None
                  |> fun x -> (id, Some(x))
            | NotFound(id) -> (id, None)
        let contextMock = Mock<IFoobleContext>()
        contextMock.SetupFunc(fun x -> x.GetMember(id, false)).Returns(memberData).End
        let query = MemberUsernameQuery.make id
        let handler = MemberUsernameQuery.makeHandler contextMock.Object
        (handler, query, contextMock)

    [<Test>]
    let ``Calling make, with successful parameters, returns expected query`` () =
        let id = Guid.NewGuid()
        let query = MemberUsernameQuery.make id
        box query :? IRequest<IMemberUsernameQueryResult> =! true
        testMemberUsernameQuery query id

    [<Test>]
    let ``Calling make success result, returns expected state`` () =
        let id = Guid.NewGuid()
        let currentPassword = randomString 32
        let username = randomString 32
        let queryResult =
            MemberChangeUsernameViewModel.make id currentPassword username
            |> MemberUsernameQuery.makeSuccessResult
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false
        testMemberChangeUsernameViewModel queryResult.ViewModel id currentPassword username

    [<Test>]
    let ``Calling not found result, returns expected state`` () =
        let queryResult = MemberUsernameQuery.notFoundResult
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true
        testInvalidOperationException "Result was not successful" <@ queryResult.ViewModel @>

    [<Test>]
    let ``Calling extension to message display read model, as success result, raises expected exception`` () =
        let id = Guid.NewGuid()
        let currentPassword = randomString 32
        let username = randomString 32
        let queryResult =
            MemberChangeUsernameViewModel.make id currentPassword username
            |> MemberUsernameQuery.makeSuccessResult
        testInvalidOperationException "Result was not unsuccessful" <@ queryResult.MapMessageDisplayReadModel() @>

    [<Test>]
    let ``Calling extension to message display read model, as not found result, returns expected read model`` () =
        let heading = "Member"
        let subHeading = "Change Username"
        let statusCode = 404
        let severity = MessageDisplayReadModel.warningSeverity
        let message = "No matching member could be found."
        let readModel =
            MemberUsernameQuery.notFoundResult
            |> fun x -> x.MapMessageDisplayReadModel()
        testMessageDisplayReadModel readModel heading subHeading statusCode severity message

    [<Test>]
    let ``Calling handler handle, with successful parameters, returns expected result`` () =
        let id = Guid.NewGuid()
        let username = randomString 32
        let (handler, query, contextMock) = setupForHandlerTest (Success(id, username))
        let queryResult = handler.Handle(query)
        contextMock.VerifyFunc((fun x -> x.GetMember(id, false)), Times.Once())
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false
        let viewModel = queryResult.ViewModel
        testMemberChangeUsernameViewModel viewModel id String.Empty username

    [<Test>]
    let ``Calling handler handle, with id not found in data store, returns expected result`` () =
        let notFoundId = Guid.NewGuid()
        let (handler, query, contextMock) = setupForHandlerTest (NotFound(notFoundId))
        let queryResult = handler.Handle(query)
        contextMock.VerifyFunc((fun x -> x.GetMember(notFoundId, false)), Times.Once())
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true
