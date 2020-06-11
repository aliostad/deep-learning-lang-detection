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
module MemberListQueryTests =

    [<NoComparison>]
    type private Result =
        | Success of seq<(Guid * string * string)>
        | NotFound

    let private setupForHandlerTest result =
        let memberData =
            match result with
            | Success(members) ->
                  members
                  |> Seq.map (fun (id, nickname, avatarData) ->
                         makeMemberData (Some(id)) None None None (Some(nickname)) (Some(avatarData)) None None None)
                  |> List.ofSeq
            | NotFound -> List.empty
        let contextMock = Mock<IFoobleContext>()
        contextMock.SetupFunc(fun x -> x.GetMembers(false)).Returns(memberData).End
        let query = MemberListQuery.make ()
        let handler = MemberListQuery.makeHandler contextMock.Object
        (handler, query, contextMock)

    [<Test>]
    let ``Calling make, returns expected query`` () =
        let query = MemberListQuery.make ()
        box query :? IRequest<IMemberListQueryResult> =! true

    [<Test>]
    let ``Calling make success result, returns expected state`` () =
        let memberCount = 5
        let members = List.init memberCount (fun _ -> (Guid.NewGuid(), randomString 64, randomString 32))
        let queryResult =
            Seq.map (fun (id, nickname, avatarData) -> MemberListReadModel.makeItem id nickname avatarData) members
            |> fun xs -> MemberListReadModel.make xs memberCount
            |> MemberListQuery.makeSuccessResult
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false
        testMemberListReadModel queryResult.ReadModel members memberCount

    [<Test>]
    let ``Calling not found result, returns expected state`` () =
        let queryResult = MemberListQuery.notFoundResult
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true
        testInvalidOperationException "Result was not successful" <@ queryResult.ReadModel @>

    [<Test>]
    let ``Calling extension to message display read model, as success result, raises expected exception`` () =
        let memberCount = 5
        let members = List.init memberCount (fun _ -> (Guid.NewGuid(), randomString 64, randomString 32))
        let queryResult =
            Seq.map (fun (id, nickname, avatarData) -> MemberListReadModel.makeItem id nickname avatarData) members
            |> fun xs -> MemberListReadModel.make xs memberCount
            |> MemberListQuery.makeSuccessResult
        testInvalidOperationException "Result was not unsuccessful" <@ queryResult.MapMessageDisplayReadModel() @>

    [<Test>]
    let ``Calling extension to message display read model, as not found result, returns expected read model`` () =
        let heading = "Member"
        let subHeading = "List"
        let statusCode = 200
        let severity = MessageDisplayReadModel.informationalSeverity
        let message = "No members have yet been added."
        let readModel =
            MemberListQuery.notFoundResult
            |> fun x -> x.MapMessageDisplayReadModel()
        testMessageDisplayReadModel readModel heading subHeading statusCode severity message

    [<Test>]
    let ``Calling handler handle, with members in data store, returns expected result`` () =
        let memberCount = 5
        let members = List.init memberCount (fun _ -> (Guid.NewGuid(), randomString 64, randomString 32))
        let (handler, query, contextMock) = setupForHandlerTest (Success(members))
        let queryResult = handler.Handle(query)
        contextMock.VerifyFunc((fun x -> x.GetMembers(false)), Times.Once())
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false
        let readModel = queryResult.ReadModel
        testMemberListReadModel readModel members memberCount

    [<Test>]
    let ``Calling handler handle, with no members in data store, returns expected result`` () =
        let (handler, query, contextMock) = setupForHandlerTest NotFound
        let queryResult = handler.Handle(query)
        contextMock.VerifyFunc((fun x -> x.GetMembers(false)), Times.Once())
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true
