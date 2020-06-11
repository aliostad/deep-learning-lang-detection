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
module MemberOtherQueryHandler =

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

    type private Result =
        | Success of Guid * string * string
        | NotFound of Guid

    let private setupForHandlerTest result =
        let resolver = AutofacDependencyResolver.Current
        let context = resolver.GetService<IFoobleContext>()
        let memberDataFactory = resolver.GetService<MemberDataFactory>()
        // remove all existing members from the data store
        List.iter (fun x -> context.DeleteMember(x)) (context.GetMembers(includeDeactivated = true))
        // add member to the data store (if required)
        match result with
        | Success(id, nickname, avatarData) ->
            randomPassword 32
              |> fun x -> Crypto.hash x 100
              |> fun x ->
                     memberDataFactory.Invoke(id, randomString 32, x, randomEmail 32, nickname, avatarData,
                         DateTime(2001, 1, 1), DateTime(2001, 1, 1), None)
            |> context.AddMember
        | NotFound(_) -> ()
        // persist changes to the data store
        context.SaveChanges()
        let query =
            match result with
            | Success(id, _, _) -> id
            | NotFound(id) -> id
            |> MemberOtherQuery.make
        let handler = resolver.GetService<IRequestHandler<IMemberOtherQuery, IMemberOtherQueryResult>>()
        (handler, query)

    [<Test>]
    let ``Calling handler handle, with successful parameters, returns expected result`` () =
        let id = Guid.NewGuid()
        let nickname = randomString 64
        let avatarData = randomString 32
        let (handler, query) = setupForHandlerTest (Success(id, nickname, avatarData))
        let queryResult = handler.Handle(query)
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false
        let viewModel = queryResult.ViewModel
        testMemberChangeOtherViewModel viewModel id nickname avatarData

    [<Test>]
    let ``Calling handler handle, with id not found in data store, returns expected result`` () =
        let notFoundId = Guid.NewGuid()
        let (handler, query) = setupForHandlerTest (NotFound(notFoundId))
        let queryResult = handler.Handle(query)
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true
