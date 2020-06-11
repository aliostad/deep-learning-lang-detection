namespace Fooble.Core.Infrastructure

open Autofac
open Autofac.Features.Variance
open Fooble.Common
open Fooble.Core
open Fooble.Persistence
open MediatR
open System
open System.Collections.Generic
open Fooble.Presentation

/// Provides the proper Autofac container registrations for the Fooble.Core assembly.
[<AllowNullLiteral>]
type CoreRegistrations =
    inherit Module

    val private Context:IFoobleContext option
    val private MemberDataFactory:MemberDataFactory option

    /// Constructs an instance of the Autofac module for the Fooble.Persistence assembly.
    new() = { Context = None; MemberDataFactory = None }

    /// <summary>
    /// Constructs an instance of the Autofac module for the Fooble.Persistence assembly.
    /// </summary>
    /// <param name="context">The data context to use.</param>
    /// <param name="memberDataFactory">The member data factory to use.</param>
    new(context, memberDataFactory) =
        ensureWith (validateRequired context "context" "Context")
        ensureWith (validateRequired memberDataFactory "memberDataFactory" "Member data factory")
        { Context = Some(context); MemberDataFactory = Some(memberDataFactory) }

    override this.Load(builder:ContainerBuilder) =
#if DEBUG
        assertWith (validateRequired builder "builder" "Builder")
#endif

        (* MediatR *)

        builder.RegisterSource(ContravariantRegistrationSource())

        ignore (builder.Register(fun x ->
            let y = x.Resolve<IComponentContext>()
            SingleInstanceFactory(fun z -> y.Resolve(z))))

        ignore (builder.Register(fun x ->
            let y = x.Resolve<IComponentContext>()
            MultiInstanceFactory(fun z ->
                y.Resolve(typedefof<IEnumerable<_>>.MakeGenericType(z)) :?> IEnumerable<obj>)))

        ignore (builder.RegisterType<Mediator>().As<IMediator>())

        (* Persistence (for registering alterative implementation) *)

        if this.Context.IsSome then
            ignore (builder.RegisterInstance(this.Context.Value).ExternallyOwned())

        if this.MemberDataFactory.IsSome then
            ignore (builder.RegisterInstance(this.MemberDataFactory.Value).ExternallyOwned())

        (* Query Handlers *)

        ignore (builder.Register(fun x -> MemberDetailQuery.makeHandler (x.Resolve<IFoobleContext>())))
        ignore (builder.Register(fun x -> MemberEmailQuery.makeHandler (x.Resolve<IFoobleContext>())))
        ignore (builder.Register(fun x -> MemberExistsQuery.makeHandler (x.Resolve<IFoobleContext>())))
        ignore (builder.Register(fun x -> MemberListQuery.makeHandler (x.Resolve<IFoobleContext>())))
        ignore (builder.Register(fun x -> MemberOtherQuery.makeHandler (x.Resolve<IFoobleContext>())))
        ignore (builder.Register(fun x -> MemberUsernameQuery.makeHandler (x.Resolve<IFoobleContext>())))

        (* Command Handlers *)

        ignore (builder.Register(fun x -> MemberChangeEmailCommand.makeHandler (x.Resolve<IFoobleContext>())))
        ignore (builder.Register(fun x -> MemberChangeOtherCommand.makeHandler (x.Resolve<IFoobleContext>())))
        ignore (builder.Register(fun x -> MemberChangePasswordCommand.makeHandler (x.Resolve<IFoobleContext>())))
        ignore (builder.Register(fun x -> MemberChangeUsernameCommand.makeHandler (x.Resolve<IFoobleContext>())))
        ignore (builder.Register(fun x -> MemberDeactivateCommand.makeHandler (x.Resolve<IFoobleContext>())))

        ignore (builder.Register(fun x ->
            MemberRegisterCommand.makeHandler (x.Resolve<IFoobleContext>()) (x.Resolve<MemberDataFactory>())))

        (* Delegates *)

        ignore (builder.Register(fun _ -> IdGenerator(fun () -> Guid.NewGuid())))
        ignore (builder.Register(fun _ -> MemberChangeEmailViewModelFactory(MemberChangeEmailViewModel.make)))
        ignore (builder.Register(fun _ -> MemberChangeOtherViewModelFactory(MemberChangeOtherViewModel.make)))

        ignore (builder.Register(fun _ ->
            InitialMemberChangePasswordViewModelFactory(MemberChangePasswordViewModel.makeInitial)))

        ignore (builder.Register(fun _ -> MemberChangePasswordViewModelFactory(MemberChangePasswordViewModel.make)))
        ignore (builder.Register(fun _ -> MemberChangeUsernameViewModelFactory(MemberChangeUsernameViewModel.make)))

        ignore (builder.Register(fun _ ->
            InitialMemberDeactivateViewModelFactory(MemberDeactivateViewModel.makeInitial)))

        ignore (builder.Register(fun _ -> MemberDeactivateViewModelFactory(MemberDeactivateViewModel.make)))
        ignore (builder.Register(fun _ -> MemberDetailQueryFactory(MemberDetailQuery.make)))
        ignore (builder.Register(fun _ -> MemberEmailQueryFactory(MemberEmailQuery.make)))
        ignore (builder.Register(fun _ -> MemberExistsQueryFactory(MemberExistsQuery.make)))
        ignore (builder.Register(fun _ -> MemberListQueryFactory(MemberListQuery.make)))
        ignore (builder.Register(fun _ -> MemberOtherQueryFactory(MemberOtherQuery.make)))
        ignore (builder.Register(fun _ -> InitialMemberRegisterViewModelFactory(MemberRegisterViewModel.makeInitial)))
        ignore (builder.Register(fun _ -> MemberRegisterViewModelFactory(MemberRegisterViewModel.make)))
        ignore (builder.Register(fun _ -> MemberUsernameQueryFactory(MemberUsernameQuery.make)))
