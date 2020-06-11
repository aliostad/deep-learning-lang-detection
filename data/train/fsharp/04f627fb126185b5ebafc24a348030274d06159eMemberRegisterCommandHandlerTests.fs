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
module MemberRegisterCommandHandlerTests =

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

    type private CommandResult = Success | UnavailableUsername | UnavailableEmail

    let private addMemberData (context:IFoobleContext) (memberDataFactory:MemberDataFactory) username email =
        let username =
            match username with
            | Some(x) -> x
            | None -> randomString 32
        let passwordData = randomString 32 |> fun x -> Crypto.hash x 100
        let email =
            match email with
            | Some(x) -> x
            | None -> randomEmail 32
        memberDataFactory.Invoke(Guid.NewGuid(), username, passwordData, email, randomEmail 64, randomEmail 32,
            DateTime(2001, 01, 01), DateTime(2001, 01, 01), None)
        |> context.AddMember

    let private setupForHandlerTest result id username password email nickname avatarData =
        let resolver = AutofacDependencyResolver.Current
        let context = resolver.GetService<IFoobleContext>()
        let memberDataFactory = resolver.GetService<MemberDataFactory>()
        // remove all existing members from the data store
        List.iter (fun x -> context.DeleteMember(x)) (context.GetMembers(includeDeactivated = true))
        // add member to the data store (if required)
        match result with
        | Success -> ()
        | UnavailableUsername -> addMemberData context memberDataFactory (Some(username)) None
        | UnavailableEmail -> addMemberData context memberDataFactory None (Some(email))
        // persist changes to the data store
        context.SaveChanges()
        let command = MemberRegisterCommand.make id username password email nickname avatarData
        let handler = resolver.GetService<IRequestHandler<IMemberRegisterCommand, IMemberRegisterCommandResult>>()
        (handler, command)

    [<Test>]
    let ``Calling handler handle, with successful parameters, returns expected result`` () =
        let id = Guid.NewGuid()
        let username = randomString 32
        let password = randomPassword 32
        let email = randomEmail 32
        let nickname = randomString 64
        let avatarData = randomString 32
        let (handler, command) = setupForHandlerTest Success id username password email nickname avatarData
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! true
        commandResult.IsUnavailableUsername =! false
        commandResult.IsUnavailableEmail =! false

    [<Test>]
    let ``Calling handler handle, with unavailable username, returns expected result`` () =
        let id = Guid.NewGuid()
        let unavailableUsername = randomString 32
        let password = randomPassword 32
        let email = randomEmail 32
        let nickname = randomString 64
        let avatarData = randomString 32
        let (handler, command) =
            setupForHandlerTest UnavailableUsername id unavailableUsername password email nickname avatarData
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! false
        commandResult.IsUnavailableUsername =! true
        commandResult.IsUnavailableEmail =! false

    [<Test>]
    let ``Calling handler handle, with unavailable email, returns expected result`` () =
        let id = Guid.NewGuid()
        let username = randomString 32
        let password = randomPassword 32
        let unavailableEmail = randomEmail 32
        let nickname = randomString 64
        let avatarData = randomString 32
        let (handler, command) =
            setupForHandlerTest UnavailableEmail id username password unavailableEmail nickname avatarData
        let commandResult = handler.Handle(command)
        commandResult.IsSuccess =! false
        commandResult.IsUnavailableUsername =! false
        commandResult.IsUnavailableEmail =! true
