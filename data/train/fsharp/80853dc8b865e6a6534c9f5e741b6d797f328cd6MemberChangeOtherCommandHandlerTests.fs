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
module MemberChangeOtherCommandHandlerTests =

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

    type private CommandResult = Success | NotFound | Unchanged

    let private setupForHandlerTest result id nickname avatarData =
        let resolver = AutofacDependencyResolver.Current
        let context = resolver.GetService<IFoobleContext>()
        let memberDataFactory = resolver.GetService<MemberDataFactory>()
        // remove all existing members from the data store
        List.iter (fun x -> context.DeleteMember(x)) (context.GetMembers(includeDeactivated = true))
        // add member to the data store (if required)
        match result with
        | Success | Unchanged ->
              randomPassword 32
              |> fun x -> Crypto.hash x 100
              |> fun x ->
                     memberDataFactory.Invoke(id, randomString 32, x, randomEmail 32, nickname, avatarData,
                         DateTime(2001, 01, 01), DateTime(2001, 01, 01), None)
              |> context.AddMember
        | NotFound -> ()
        // persist changes to the data store
        context.SaveChanges()
        let command = MemberChangeOtherCommand.make id nickname avatarData
        let handler =
            resolver.GetService<IRequestHandler<IMemberChangeOtherCommand, IMemberChangeOtherCommandResult>>()
        (handler, command)

    [<Test>]
    let ``Calling handler handle, with successful parameters, returns expected result`` () =
        let id = Guid.NewGuid()
        let nickname = randomString 64
        let avatarData = randomString 32
        let (handler, command) = setupForHandlerTest Success id nickname avatarData
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! true
        commandResult.IsNotFound =! false

    [<Test>]
    let ``Calling handler handle, with id not found in data store, returns expected result`` () =
        let notFoundId = Guid.NewGuid()
        let nickname = randomString 64
        let avatarData = randomString 32
        let (handler, command) = setupForHandlerTest NotFound notFoundId nickname avatarData
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! false
        commandResult.IsNotFound =! true

    [<Test>]
    let ``Calling handler handle, with no change from current nickname or avatar data, returns expected result`` () =
        let id = Guid.NewGuid()
        let unchangedNickname = randomString 64
        let unchangedAvatarData = randomString 32
        let (handler, command) = setupForHandlerTest Unchanged id unchangedNickname unchangedAvatarData
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! true
        commandResult.IsNotFound =! false
