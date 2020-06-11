namespace Fooble.Core

open Fooble.Common
open Fooble.Persistence
open MediatR
open System

[<RequireQualifiedAccess>]
module internal MemberChangeOtherCommand =

    [<DefaultAugmentation(false)>]
    type private MemberChangeOtherCommandImpl =
        | Command of id:Guid * nickname:string * avatarData:string

        interface IMemberChangeOtherCommand with

            member this.Id
                with get() =
                    match this with
                    | Command(id = x) -> x

            member this.Nickname
                with get() =
                    match this with
                    | Command(nickname = x) -> x

            member this.AvatarData
                with get() =
                    match this with
                    | Command(avatarData = x) -> x

    let make id nickname avatarData =
#if DEBUG
        assertWith (validateMemberId id)
        assertWith (validateMemberNickname nickname)
        assertWith (validateMemberAvatarData avatarData)
#endif
        Command(id, nickname, avatarData) :> IMemberChangeOtherCommand

    [<DefaultAugmentation(false)>]
    type private MemberChangeOtherCommandResultImpl =
        | Success
        | NotFound

        interface IMemberChangeOtherCommandResult with

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

    let successResult = Success :> IMemberChangeOtherCommandResult
    let notFoundResult = NotFound :> IMemberChangeOtherCommandResult

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberChangeOtherCommandHandlerImpl =
        | CommandHandler of context:IFoobleContext

        member private this.Context
            with get() =
                match this with
                | CommandHandler(context = x) -> x

        interface IRequestHandler<IMemberChangeOtherCommand, IMemberChangeOtherCommandResult> with

            member this.Handle(message) =
#if DEBUG
                assertWith (validateRequired message "message" "Message")
#endif

                match this.Context.GetMember(message.Id, includeDeactivated = false) with
                | None -> notFoundResult
                | Some(x) ->

                match message.Nickname = x.Nickname && message.AvatarData = x.AvatarData with
                | true -> successResult
                | _ ->

                if message.Nickname <> x.Nickname
                    then x.Nickname <- message.Nickname

                if message.AvatarData <> x.AvatarData
                    then x.AvatarData <- message.AvatarData

                this.Context.SaveChanges()
                successResult

    let makeHandler context =
#if DEBUG
        assertWith (validateRequired context "context" "Context")
#endif
        CommandHandler(context) :> IRequestHandler<IMemberChangeOtherCommand, IMemberChangeOtherCommandResult>
