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
module MemberOtherQueryTests =

    type private Result =
        | Success of Guid * string * string
        | NotFound of Guid

    let private setupForHandlerTest result =
        let (id, memberData) =
            match result with
            | Success(id, nickname, avatarData) ->
                  makeMemberData (Some(id)) None None None (Some(nickname)) (Some(avatarData)) None None None
                  |> fun x -> (id, Some(x))
            | NotFound(id) -> (id, None)
        let contextMock = Mock<IFoobleContext>()
        contextMock.SetupFunc(fun x -> x.GetMember(id, false)).Returns(memberData).End
        let query = MemberOtherQuery.make id
        let handler = MemberOtherQuery.makeHandler contextMock.Object
        (handler, query, contextMock)

    [<Test>]
    let ``Calling make, with successful parameters, returns expected query`` () =
        let id = Guid.NewGuid()
        let query = MemberOtherQuery.make id
        box query :? IRequest<IMemberOtherQueryResult> =! true
        testMemberOtherQuery query id

    [<Test>]
    let ``Calling make success result, returns expected state`` () =
        let id = Guid.NewGuid()
        let nickname = randomString 64
        let avatarData = randomString 32
        let queryResult =
            MemberChangeOtherViewModel.make id nickname avatarData
            |> MemberOtherQuery.makeSuccessResult
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false
        testMemberChangeOtherViewModel queryResult.ViewModel id nickname avatarData

    [<Test>]
    let ``Calling not found result, returns expected state`` () =
        let queryResult = MemberOtherQuery.notFoundResult
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true
        testInvalidOperationException "Result was not successful" <@ queryResult.ViewModel @>

    [<Test>]
    let ``Calling extension to message display read model, as success result, raises expected exception`` () =
        let id = Guid.NewGuid()
        let nickname = randomString 64
        let avatarData = randomString 32
        let queryResult =
            MemberChangeOtherViewModel.make id nickname avatarData
            |> MemberOtherQuery.makeSuccessResult
        testInvalidOperationException "Result was not unsuccessful" <@ queryResult.MapMessageDisplayReadModel() @>

    [<Test>]
    let ``Calling extension to message display read model, as not found result, returns expected read model`` () =
        let heading = "Member"
        let subHeading = "Change Other"
        let statusCode = 404
        let severity = MessageDisplayReadModel.warningSeverity
        let message = "No matching member could be found."
        let readModel =
            MemberOtherQuery.notFoundResult
            |> fun x -> x.MapMessageDisplayReadModel()
        testMessageDisplayReadModel readModel heading subHeading statusCode severity message

    [<Test>]
    let ``Calling handler handle, with successful parameters, returns expected result`` () =
        let id = Guid.NewGuid()
        let nickname = randomString 64
        let avatarData = randomString 32
        let (handler, query, contextMock) = setupForHandlerTest (Success(id, nickname, avatarData))
        let queryResult = handler.Handle(query)
        contextMock.VerifyFunc((fun x -> x.GetMember(id, false)), Times.Once())
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false
        let viewModel = queryResult.ViewModel
        testMemberChangeOtherViewModel viewModel id nickname avatarData

    [<Test>]
    let ``Calling handler handle, with id not found in data store, returns expected result`` () =
        let notFoundId = Guid.NewGuid()
        let (handler, query, contextMock) = setupForHandlerTest (NotFound(notFoundId))
        let queryResult = handler.Handle(query)
        contextMock.VerifyFunc((fun x -> x.GetMember(notFoundId, false)), Times.Once())
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true
