namespace Fooble.IntegrationTest

open Autofac
open Fooble.Common
open Fooble.Core
open Fooble.Core.Infrastructure
open Fooble.Persistence
open Fooble.Presentation
open MediatR
open Moq
open NUnit.Framework
open Swensen.Unquote
open System

[<TestFixture>]
module CoreRegistrationsTests =

    [<Test>]
    let ``Constructing, returns expected result`` () =
        ignore (CoreRegistrations())

    [<Test>]
    let ``Constructing, with valid parameters, returns expected result`` () =
        ignore (CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>()))

    [<Test>]
    let ``Constructing, with null member data factory, raises expected exception`` () =
        testArgumentException "memberDataFactory" "Member data factory is required"
            <@ CoreRegistrations(Mock.Of<IFoobleContext>(), null) @>

    [<Test>]
    let ``Registering autofac container, properly registers id generator`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let idGenerator = container.Resolve<IdGenerator>()
        isNull idGenerator =! false
        let idCount = 1000
        let ids =
            List.init idCount (fun _ -> idGenerator.Invoke())
            |> Set.ofList
        Set.count ids =! idCount
        Set.contains Guid.Empty ids =! false

    [<Test>]
    let ``Registering autofac container, properly registers initial member change password view model factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let initialMemberChangePasswordViewModelFactory =
            container.Resolve<InitialMemberChangePasswordViewModelFactory>()
        isNull initialMemberChangePasswordViewModelFactory =! false
        let id = Guid.NewGuid()
        let viewModel = initialMemberChangePasswordViewModelFactory.Invoke(id)
        testMemberChangePasswordViewModel viewModel id String.Empty String.Empty String.Empty

    [<Test>]
    let ``Registering autofac container, properly registers initial deactivate view model factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let initialMemberDeactivateViewModelFactory = container.Resolve<InitialMemberDeactivateViewModelFactory>()
        isNull initialMemberDeactivateViewModelFactory =! false
        let id = Guid.NewGuid()
        let viewModel = initialMemberDeactivateViewModelFactory.Invoke(id)
        testMemberDeactivateViewModel viewModel id String.Empty

    [<Test>]
    let ``Registering autofac container, properly registers initial register view model factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let initialMemberRegisterViewModelFactory = container.Resolve<InitialMemberRegisterViewModelFactory>()
        isNull initialMemberRegisterViewModelFactory =! false
        let viewModel = initialMemberRegisterViewModelFactory.Invoke()
        testMemberRegisterViewModel viewModel String.Empty String.Empty String.Empty String.Empty String.Empty None

    [<Test>]
    let ``Registering autofac container, properly registers mediator`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let mediator = container.Resolve<IMediator>()
        isNull mediator =! false

    [<Test>]
    let ``Registering autofac container, properly registers member change email command handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler =
            container.Resolve<IRequestHandler<IMemberChangeEmailCommand, IMemberChangeEmailCommandResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers member change email view model factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberChangeEmailViewModelFactory = container.Resolve<MemberChangeEmailViewModelFactory>()
        isNull memberChangeEmailViewModelFactory =! false
        let id = Guid.NewGuid()
        let currentPassword = randomPassword 32 |> fun x -> Crypto.hash x 100
        let email = randomEmail 32
        let viewModel = memberChangeEmailViewModelFactory.Invoke(id, currentPassword, email)
        testMemberChangeEmailViewModel viewModel id currentPassword email

    [<Test>]
    let ``Registering autofac container, properly registers member change other command handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler =
            container.Resolve<IRequestHandler<IMemberChangeOtherCommand, IMemberChangeOtherCommandResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers member change other view model factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberChangeOtherViewModelFactory = container.Resolve<MemberChangeOtherViewModelFactory>()
        isNull memberChangeOtherViewModelFactory =! false
        let id = Guid.NewGuid()
        let nickname = randomString 64
        let avatarData = randomString 32
        let viewModel = memberChangeOtherViewModelFactory.Invoke(id, nickname, avatarData)
        testMemberChangeOtherViewModel viewModel id nickname avatarData

    [<Test>]
    let ``Registering autofac container, properly registers member change password command handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler =
            container.Resolve<IRequestHandler<IMemberChangePasswordCommand, IMemberChangePasswordCommandResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers member change password view model factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberChangePasswordViewModelFactory = container.Resolve<MemberChangePasswordViewModelFactory>()
        isNull memberChangePasswordViewModelFactory =! false
        let id = Guid.NewGuid()
        let currentPassword = randomPassword 32 |> fun x -> Crypto.hash x 100
        let password = randomPassword 32
        let confirmPassword = password
        let viewModel = memberChangePasswordViewModelFactory.Invoke(id, currentPassword, password, confirmPassword)
        testMemberChangePasswordViewModel viewModel id currentPassword password confirmPassword

    [<Test>]
    let ``Registering autofac container, properly registers member change username command handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler =
            container.Resolve<IRequestHandler<IMemberChangeUsernameCommand, IMemberChangeUsernameCommandResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers member change username view model factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberChangeUsernameViewModelFactory = container.Resolve<MemberChangeUsernameViewModelFactory>()
        isNull memberChangeUsernameViewModelFactory =! false
        let id = Guid.NewGuid()
        let currentPassword = randomPassword 32 |> fun x -> Crypto.hash x 100
        let username = randomString 32
        let viewModel = memberChangeUsernameViewModelFactory.Invoke(id, currentPassword, username)
        testMemberChangeUsernameViewModel viewModel id currentPassword username

    [<Test>]
    let ``Registering autofac container, properly registers member deactivate command handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler = container.Resolve<IRequestHandler<IMemberDeactivateCommand, IMemberDeactivateCommandResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers member deactivate view model factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberDeactivateViewModelFactory = container.Resolve<MemberDeactivateViewModelFactory>()
        isNull memberDeactivateViewModelFactory =! false
        let id = Guid.NewGuid()
        let currentPassword = randomPassword 32 |> fun x -> Crypto.hash x 100
        let viewModel = memberDeactivateViewModelFactory.Invoke(id, currentPassword)
        testMemberDeactivateViewModel viewModel id currentPassword

    [<Test>]
    let ``Registering autofac container, properly registers member detail query factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberDetailQueryFactory = container.Resolve<MemberDetailQueryFactory>()
        isNull memberDetailQueryFactory =! false
        let id = Guid.NewGuid()
        let query = memberDetailQueryFactory.Invoke(id)
        testMemberDetailQuery query id

    [<Test>]
    let ``Registering autofac container, properly registers member detail query handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler = container.Resolve<IRequestHandler<IMemberDetailQuery, IMemberDetailQueryResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers member email query factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberEmailQueryFactory = container.Resolve<MemberEmailQueryFactory>()
        isNull memberEmailQueryFactory =! false
        let id = Guid.NewGuid()
        let query = memberEmailQueryFactory.Invoke(id)
        testMemberEmailQuery query id

    [<Test>]
    let ``Registering autofac container, properly registers member email query handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler = container.Resolve<IRequestHandler<IMemberEmailQuery, IMemberEmailQueryResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers member exists query factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberExistsQueryFactory = container.Resolve<MemberExistsQueryFactory>()
        isNull memberExistsQueryFactory =! false
        let id = Guid.NewGuid()
        let query = memberExistsQueryFactory.Invoke(id)
        testMemberExistsQuery query id

    [<Test>]
    let ``Registering autofac container, properly registers member exists query handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler = container.Resolve<IRequestHandler<IMemberExistsQuery, IMemberExistsQueryResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers member list query factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberListQueryFactory = container.Resolve<MemberListQueryFactory>()
        isNull memberListQueryFactory =! false
        ignore (memberListQueryFactory.Invoke())

    [<Test>]
    let ``Registering autofac container, properly registers member list query handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler = container.Resolve<IRequestHandler<IMemberListQuery, IMemberListQueryResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers member other query factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberOtherQueryFactory = container.Resolve<MemberOtherQueryFactory>()
        isNull memberOtherQueryFactory =! false
        let id = Guid.NewGuid()
        let query = memberOtherQueryFactory.Invoke(id)
        testMemberOtherQuery query id

    [<Test>]
    let ``Registering autofac container, properly registers member other query handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler = container.Resolve<IRequestHandler<IMemberOtherQuery, IMemberOtherQueryResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers member register command handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler = container.Resolve<IRequestHandler<IMemberRegisterCommand, IMemberRegisterCommandResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers member register view model factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberRegisterViewModelFactory = container.Resolve<MemberRegisterViewModelFactory>()
        isNull memberRegisterViewModelFactory =! false
        let username = randomString 32
        let password = randomPassword 32
        let confirmPassword = password
        let email = randomEmail 32
        let nickname = randomString 64
        let avatarData = randomString 32
        let viewModel =
            memberRegisterViewModelFactory.Invoke(username, password, confirmPassword, email, nickname, avatarData)
        testMemberRegisterViewModel viewModel username password confirmPassword email nickname (Some(avatarData))

    [<Test>]
    let ``Registering autofac container, properly registers member username query factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let memberUsernameQueryFactory = container.Resolve<MemberUsernameQueryFactory>()
        isNull memberUsernameQueryFactory =! false
        let id = Guid.NewGuid()
        let query = memberUsernameQueryFactory.Invoke(id)
        testMemberUsernameQuery query id

    [<Test>]
    let ``Registering autofac container, properly registers member username query handler`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let handler = container.Resolve<IRequestHandler<IMemberUsernameQuery, IMemberUsernameQueryResult>>()
        isNull handler =! false

    [<Test>]
    let ``Registering autofac container, properly registers multi-instance factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let factory = container.Resolve<MultiInstanceFactory>()
        isNull factory =! false

    [<Test>]
    let ``Registering autofac container, properly registers single instance factory`` () =
        let builder = ContainerBuilder()
        ignore (builder.RegisterModule(CoreRegistrations(Mock.Of<IFoobleContext>(), Mock.Of<MemberDataFactory>())))
        use container = builder.Build()
        let factory = container.Resolve<SingleInstanceFactory>()
        isNull factory =! false
