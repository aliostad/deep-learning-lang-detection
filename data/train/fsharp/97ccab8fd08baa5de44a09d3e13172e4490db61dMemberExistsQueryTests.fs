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
module MemberExistsQueryTests =

    type private Result =
        | Success of Guid
        | NotFound of Guid

    let private setupForHandlerTest result =
        let contextMock = Mock<IFoobleContext>()
        match result with
        | Success(id) -> contextMock.SetupFunc(fun x -> x.ExistsMemberId(id, false)).Returns(true).End
        | NotFound(id) -> contextMock.SetupFunc(fun x -> x.ExistsMemberId(id, false)).Returns(false).End
        let query =
            match result with
            | Success(id) -> MemberExistsQuery.make id
            | NotFound(id) -> MemberExistsQuery.make id
        let handler = MemberExistsQuery.makeHandler contextMock.Object
        (handler, query, contextMock)

    [<Test>]
    let ``Calling make, with successful parameters, returns expected query`` () =
        let id = Guid.NewGuid()
        let query = MemberExistsQuery.make id
        box query :? IRequest<IMemberExistsQueryResult> =! true
        testMemberExistsQuery query id

    [<Test>]
    let ``Calling success result, returns expected state`` () =
        let queryResult = MemberExistsQuery.successResult
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false

    [<Test>]
    let ``Calling not found result, returns expected state`` () =
        let queryResult = MemberExistsQuery.notFoundResult
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true

    [<Test>]
    let ``Calling extension to message display read model, as success result, raises expected exception`` () =
        let queryResult = MemberExistsQuery.successResult
        testInvalidOperationException "Result was not unsuccessful"
            <@ queryResult.MapMessageDisplayReadModel("Exists") @>

    [<Test>]
    let ``Calling extension to message display read model, as not found result, returns expected read model`` () =
        let heading = "Member"
        let subHeading = "Exists"
        let statusCode = 404
        let severity = MessageDisplayReadModel.warningSeverity
        let message = "No matching member could be found."
        let readModel =
            MemberExistsQuery.notFoundResult
            |> fun x -> x.MapMessageDisplayReadModel("Exists")
        testMessageDisplayReadModel readModel heading subHeading statusCode severity message

    [<Test>]
    let ``Calling handler handle, with successful parameters, returns expected result`` () =
        let id = Guid.NewGuid()
        let (handler, query, contextMock) = setupForHandlerTest (Success(id))
        let queryResult = handler.Handle(query)
        contextMock.VerifyFunc((fun x -> x.ExistsMemberId(id, false)), Times.Once())
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false

    [<Test>]
    let ``Calling handler handle, with id not found in data store, returns expected result`` () =
        let notFoundId = Guid.NewGuid()
        let (handler, query, contextMock) = setupForHandlerTest (NotFound(notFoundId))
        let queryResult = handler.Handle(query)
        contextMock.VerifyFunc((fun x -> x.ExistsMemberId(notFoundId, false)), Times.Once())
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true
