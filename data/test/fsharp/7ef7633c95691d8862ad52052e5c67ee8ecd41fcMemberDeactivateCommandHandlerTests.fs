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
module MemberDeactivateCommandHandlerTests =

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

    type private CommandResult = Success | NotFound | IncorrectPassword

    let private addMemberData (context:IFoobleContext) (memberDataFactory:MemberDataFactory) id currentPassword =
        let passwordData =
            match currentPassword with
            | Some(x) -> x
            | None -> randomPassword 32
            |> fun x -> Crypto.hash x 100
        memberDataFactory.Invoke(id, randomString 32, passwordData, randomEmail 32, randomString 64, randomString 32,
            DateTime(2001, 01, 01), DateTime(2001, 01, 01), None)
        |> context.AddMember

    let private setupForHandlerTest result id currentPassword =
        let resolver = AutofacDependencyResolver.Current
        let context = resolver.GetService<IFoobleContext>()
        let memberDataFactory = resolver.GetService<MemberDataFactory>()
        // remove all existing members from the data store
        List.iter (fun x -> context.DeleteMember(x)) (context.GetMembers(includeDeactivated = true))
        // add member to the data store (if required)
        match result with
        | Success -> addMemberData context memberDataFactory id (Some(currentPassword))
        | NotFound -> ()
        | IncorrectPassword -> addMemberData context memberDataFactory id None
        // persist changes to the data store
        context.SaveChanges()
        let command = MemberDeactivateCommand.make id currentPassword
        let handler =
            resolver.GetService<IRequestHandler<IMemberDeactivateCommand, IMemberDeactivateCommandResult>>()
        (handler, command)

    [<Test>]
    let ``Calling handler handle, with successful parameters, returns expected result`` () =
        let id = Guid.NewGuid()
        let currentPassword = randomPassword 32
        let (handler, command) = setupForHandlerTest Success id currentPassword
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! true
        commandResult.IsNotFound =! false
        commandResult.IsIncorrectPassword =! false

    [<Test>]
    let ``Calling handler handle, with id not found in data store, returns expected result`` () =
        let notFoundId = Guid.NewGuid()
        let currentPassword = randomPassword 32
        let (handler, command) = setupForHandlerTest NotFound notFoundId currentPassword
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! false
        commandResult.IsNotFound =! true
        commandResult.IsIncorrectPassword =! false

    [<Test>]
    let ``Calling handler handle, with incorrect password, returns expected result`` () =
        let id = Guid.NewGuid()
        let incorrectPassword = randomPassword 32
        let (handler, command) = setupForHandlerTest IncorrectPassword id incorrectPassword
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! false
        commandResult.IsNotFound =! false
        commandResult.IsIncorrectPassword =! true
