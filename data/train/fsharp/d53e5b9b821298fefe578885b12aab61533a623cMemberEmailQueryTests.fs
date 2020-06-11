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
module MemberEmailQueryTests =

    type private Result =
        | Success of Guid * string
        | NotFound of Guid

    let private setupForHandlerTest result =
        let (id, memberData) =
            match result with
            | Success(id, email) ->
                  makeMemberData (Some(id)) None None (Some(email)) None None None None None
                  |> fun x -> (id, Some(x))
            | NotFound(id) -> (id, None)
        let contextMock = Mock<IFoobleContext>()
        contextMock.SetupFunc(fun x -> x.GetMember(id, false)).Returns(memberData).End
        let query = MemberEmailQuery.make id
        let handler = MemberEmailQuery.makeHandler contextMock.Object
        (handler, query, contextMock)

    [<Test>]
    let ``Calling make, with successful parameters, returns expected query`` () =
        let id = Guid.NewGuid()
        let query = MemberEmailQuery.make id
        box query :? IRequest<IMemberEmailQueryResult> =! true
        testMemberEmailQuery query id

    [<Test>]
    let ``Calling make success result, returns expected state`` () =
        let id = Guid.NewGuid()
        let currentPassword = randomEmail 32
        let email = randomEmail 32
        let queryResult =
            MemberChangeEmailViewModel.make id currentPassword email
            |> MemberEmailQuery.makeSuccessResult
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false
        testMemberChangeEmailViewModel queryResult.ViewModel id currentPassword email

    [<Test>]
    let ``Calling not found result, returns expected state`` () =
        let queryResult = MemberEmailQuery.notFoundResult
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true
        testInvalidOperationException "Result was not successful" <@ queryResult.ViewModel @>

    [<Test>]
    let ``Calling extension to message display read model, as success result, raises expected exception`` () =
        let id = Guid.NewGuid()
        let currentPassword = randomEmail 32
        let email = randomEmail 32
        let queryResult =
            MemberChangeEmailViewModel.make id currentPassword email
            |> MemberEmailQuery.makeSuccessResult
        testInvalidOperationException "Result was not unsuccessful" <@ queryResult.MapMessageDisplayReadModel() @>

    [<Test>]
    let ``Calling extension to message display read model, as not found result, returns expected read model`` () =
        let heading = "Member"
        let subHeading = "Change Email"
        let statusCode = 404
        let severity = MessageDisplayReadModel.warningSeverity
        let message = "No matching member could be found."
        let readModel =
            MemberEmailQuery.notFoundResult
            |> fun x -> x.MapMessageDisplayReadModel()
        testMessageDisplayReadModel readModel heading subHeading statusCode severity message

    [<Test>]
    let ``Calling handler handle, with successful parameters, returns expected result`` () =
        let id = Guid.NewGuid()
        let email = randomEmail 32
        let (handler, query, contextMock) = setupForHandlerTest (Success(id, email))
        let queryResult = handler.Handle(query)
        contextMock.VerifyFunc((fun x -> x.GetMember(id, false)), Times.Once())
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false
        let viewModel = queryResult.ViewModel
        testMemberChangeEmailViewModel viewModel id String.Empty email

    [<Test>]
    let ``Calling handler handle, with id not found in data store, returns expected result`` () =
        let notFoundId = Guid.NewGuid()
        let (handler, query, contextMock) = setupForHandlerTest (NotFound(notFoundId))
        let queryResult = handler.Handle(query)
        contextMock.VerifyFunc((fun x -> x.GetMember(notFoundId, false)), Times.Once())
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true
