namespace Fooble.Core

open Fooble.Common
open Fooble.Persistence
open MediatR
open System

[<RequireQualifiedAccess>]
module internal MemberDeactivateCommand =

    [<DefaultAugmentation(false)>]
    type private MemberDeactivateCommandImpl =
        | Command of id:Guid * currentPassword:string

        interface IMemberDeactivateCommand with

            member this.Id
                with get() =
                    match this with
                    | Command(id = x) -> x

            member this.CurrentPassword
                with get() =
                    match this with
                    | Command(currentPassword = x) -> x

    let make id currentPassword =
#if DEBUG
        assertWith (validateMemberId id)
#endif
        Command(id, currentPassword) :> IMemberDeactivateCommand

    [<DefaultAugmentation(false)>]
    type private MemberDeactivateCommandResultImpl =
        | Success
        | NotFound
        | IncorrectPassword

        interface IMemberDeactivateCommandResult with

            member this.IsSuccess
                with get() =
                    match this with
                    | Success _ -> true
                    | _ -> false

            member this.IsNotFound
                with get() =
                    match this with
                    | NotFound -> true
                    | _ -> false

            member this.IsIncorrectPassword
                with get() =
                    match this with
                    | IncorrectPassword -> true
                    | _ -> false

    let successResult = Success :> IMemberDeactivateCommandResult
    let notFoundResult = NotFound :> IMemberDeactivateCommandResult
    let incorrectPasswordResult = IncorrectPassword :> IMemberDeactivateCommandResult

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberDeactivateCommandHandlerImpl =
        | CommandHandler of context:IFoobleContext

        member private this.Context
            with get() =
                match this with
                | CommandHandler(context = x) -> x

        interface IRequestHandler<IMemberDeactivateCommand, IMemberDeactivateCommandResult> with

            member this.Handle(message) =
#if DEBUG
                assertWith (validateRequired message "message" "Message")
#endif

                match this.Context.GetMember(message.Id, includeDeactivated = false) with
                | None -> notFoundResult
                | Some(x) ->

                match Crypto.verify x.PasswordData message.CurrentPassword with
                | false -> incorrectPasswordResult
                | _ ->

                x.DeactivatedOn <- Some(DateTime.UtcNow)

                this.Context.SaveChanges()
                successResult

    let makeHandler context =
#if DEBUG
        assertWith (validateRequired context "context" "Context")
#endif
        CommandHandler(context) :> IRequestHandler<IMemberDeactivateCommand, IMemberDeactivateCommandResult>
