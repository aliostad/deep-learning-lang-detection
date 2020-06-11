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
module MemberChangeUsernameCommandHandlerTests =

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

    type private CommandResult = Success | NotFound | IncorrectPassword | Unchanged | UnavailableUsername

    let private addMemberData (context:IFoobleContext) (memberDataFactory:MemberDataFactory) id currentPassword
        username =

        let id =
            match id with
            | Some(x) -> x
            | None -> Guid.NewGuid()
        let passwordData =
            match currentPassword with
            | Some(x) -> x
            | None -> randomPassword 32
            |> fun x -> Crypto.hash x 100
        let username =
            match username with
            | Some(x) -> x
            | None -> randomString 32
        memberDataFactory.Invoke(id, username, passwordData, randomEmail 32, randomString 64, randomString 32,
            DateTime(2001, 01, 01), DateTime(2001, 01, 01), None)
        |> context.AddMember

    let private setupForHandlerTest result id currentPassword username =
        let resolver = AutofacDependencyResolver.Current
        let context = resolver.GetService<IFoobleContext>()
        let memberDataFactory = resolver.GetService<MemberDataFactory>()
        // remove all existing members from the data store
        List.iter (fun x -> context.DeleteMember(x)) (context.GetMembers(includeDeactivated = true))
        // add member to the data store (if required)
        match result with
        | Success -> addMemberData context memberDataFactory (Some(id)) (Some(currentPassword)) None
        | NotFound -> ()
        | IncorrectPassword -> addMemberData context memberDataFactory (Some(id)) None None
        | Unchanged -> addMemberData context memberDataFactory (Some(id)) (Some(currentPassword)) (Some(username))
        | UnavailableUsername ->
              addMemberData context memberDataFactory None None (Some(username))
              addMemberData context memberDataFactory (Some(id)) (Some(currentPassword)) None
        // persist changes to the data store
        context.SaveChanges()
        let command = MemberChangeUsernameCommand.make id currentPassword username
        let handler =
            resolver.GetService<IRequestHandler<IMemberChangeUsernameCommand, IMemberChangeUsernameCommandResult>>()
        (handler, command)

    [<Test>]
    let ``Calling handler handle, with successful parameters, returns expected result`` () =
        let id = Guid.NewGuid()
        let currentPassword = randomPassword 32
        let username = randomString 32
        let (handler, command) = setupForHandlerTest Success id currentPassword username
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! true
        commandResult.IsNotFound =! false
        commandResult.IsIncorrectPassword =! false
        commandResult.IsUnavailableUsername =! false

    [<Test>]
    let ``Calling handler handle, with id not found in data store, returns expected result`` () =
        let notFoundId = Guid.NewGuid()
        let currentPassword = randomPassword 32
        let username = randomString 32
        let (handler, command) = setupForHandlerTest NotFound notFoundId currentPassword username
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! false
        commandResult.IsNotFound =! true
        commandResult.IsIncorrectPassword =! false
        commandResult.IsUnavailableUsername =! false

    [<Test>]
    let ``Calling handler handle, with incorrect password, returns expected result`` () =
        let id = Guid.NewGuid()
        let incorrectPassword = randomPassword 32
        let username = randomString 32
        let (handler, command) = setupForHandlerTest IncorrectPassword id incorrectPassword username
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! false
        commandResult.IsNotFound =! false
        commandResult.IsIncorrectPassword =! true
        commandResult.IsUnavailableUsername =! false

    [<Test>]
    let ``Calling handler handle, with no change from current username, returns expected result`` () =
        let id = Guid.NewGuid()
        let currentPassword = randomPassword 32
        let unchangedUsername = randomString 32
        let (handler, command) = setupForHandlerTest Unchanged id currentPassword unchangedUsername
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! true
        commandResult.IsNotFound =! false
        commandResult.IsIncorrectPassword =! false
        commandResult.IsUnavailableUsername =! false

    [<Test>]
    let ``Calling handler handle, with unavailable username, returns expected result`` () =
        let id = Guid.NewGuid()
        let currentPassword = randomPassword 32
        let unavailableUsername = randomString 32
        let (handler, command) =
            setupForHandlerTest UnavailableUsername id currentPassword unavailableUsername
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! false
        commandResult.IsNotFound =! false
        commandResult.IsIncorrectPassword =! false
        commandResult.IsUnavailableUsername =! true
