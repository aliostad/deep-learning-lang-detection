namespace Fooble.IntegrationTest

open Autofac.Integration.Mvc
open Fooble.Common
open Fooble.Core
open Fooble.Persistence
open MediatR
open NUnit.Framework
open Swensen.Unquote
open System
open System.Web.Mvc

[<TestFixture>]
module MemberListQueryHandlerTests =

    let mutable private originalResolver = null
    let mutable private scopeProvider = null

    [<OneTimeSetUp>]
    let oneTimeSetup () =
        let result = setupDependencyResolver ()
        scopeProvider <- fst result
        originalResolver <- snd result

    [<OneTimeTearDown>]
    let oneTimeTeardown () = DependencyResolver.SetResolver(originalResolver)

    [<TearDown>]
    let teardown () = scopeProvider.EndLifetimeScope()

    [<NoComparison>]
    type private Result =
        | Success of seq<(Guid * string * string)>
        | NotFound

    let private setupForHandlerTest result =
        let resolver = AutofacDependencyResolver.Current
        let context = resolver.GetService<IFoobleContext>()
        let memberDataFactory = resolver.GetService<MemberDataFactory>()
        // remove all existing members from the data store
        List.iter (fun x -> context.DeleteMember(x)) (context.GetMembers(includeDeactivated = true))
        // add member to the data store (if required)
        match result with
        | Success(members) ->
              Seq.map (fun (id, nickname, avatarData) ->
                  randomPassword 32
                  |> fun x -> Crypto.hash x 100
                  |> fun x ->
                         memberDataFactory.Invoke(id, randomString 32, x, randomEmail 32, nickname, avatarData,
                             DateTime(2001, 1, 1), DateTime(2001, 1, 1), None)) members
              |> Seq.iter (fun x -> context.AddMember(x))
        | NotFound -> ()
        // persist changes to the data store
        context.SaveChanges()
        let query = MemberListQuery.make ()
        let handler = resolver.GetService<IRequestHandler<IMemberListQuery, IMemberListQueryResult>>()
        (handler, query)

    [<Test>]
    let ``Calling handler handle, with members in data store, returns expected result`` () =
        let memberCount = 5
        let members = List.init memberCount (fun _ -> (Guid.NewGuid(), randomString 64, randomString 32))
        let (handler, query) = setupForHandlerTest (Success(members))
        let queryResult = handler.Handle(query)
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false
        let readModel = queryResult.ReadModel
        testMemberListReadModel readModel members memberCount

    [<Test>]
    let ``Calling handler handle, with no members in data store, returns expected result`` () =
        let (handler, query) = setupForHandlerTest NotFound
        let queryResult = handler.Handle(query)
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true

