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
module MemberUsernameQueryHandlerTests =

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
        | Success of Guid * string
        | NotFound of Guid

    let private setupForHandlerTest result =
        let resolver = AutofacDependencyResolver.Current
        let context = resolver.GetService<IFoobleContext>()
        let memberDataFactory = resolver.GetService<MemberDataFactory>()
        // remove all existing members from the data store
        List.iter (fun x -> context.DeleteMember(x)) (context.GetMembers(includeDeactivated = true))
        // add member to the data store (if required)
        match result with
        | Success(id, username) ->
              randomPassword 32
              |> fun x -> Crypto.hash x 100
              |> fun x ->
                     memberDataFactory.Invoke(id, username, x, randomEmail 32, randomString 64, randomString 32,
                         DateTime(2001, 1, 1), DateTime(2001, 1, 1), None)
              |> context.AddMember
        | NotFound(_) -> ()
        // persist changes to the data store
        context.SaveChanges()
        let query =
            match result with
            | Success(id, _) -> id
            | NotFound(id) -> id
            |> MemberUsernameQuery.make
        let handler = resolver.GetService<IRequestHandler<IMemberUsernameQuery, IMemberUsernameQueryResult>>()
        (handler, query)

    [<Test>]
    let ``Calling handler handle, with successful parameters, returns expected result`` () =
        let id = Guid.NewGuid()
        let username = randomString 32
        let (handler, query) = setupForHandlerTest (Success(id, username))
        let queryResult = handler.Handle(query)
        queryResult.IsSuccess =! true
        queryResult.IsNotFound =! false
        let viewModel = queryResult.ViewModel
        testMemberChangeUsernameViewModel viewModel id String.Empty username

    [<Test>]
    let ``Calling handler handle, with id not found in data store, returns expected result`` () =
        let notFoundId = Guid.NewGuid()
        let (handler, query) = setupForHandlerTest (NotFound(notFoundId))
        let queryResult = handler.Handle(query)
        queryResult.IsSuccess =! false
        queryResult.IsNotFound =! true
