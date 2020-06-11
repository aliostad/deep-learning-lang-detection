namespace Fooble.Core

open Fooble.Common
open Fooble.Persistence
open Fooble.Presentation
open MediatR
open System

[<RequireQualifiedAccess>]
module internal MemberDetailQuery =

    [<DefaultAugmentation(false)>]
    type private MemberDetailQueryImpl =
        | Query of id:Guid

        interface IMemberDetailQuery with

            member this.Id
                with get() =
                    match this with
                    | Query(id = x) -> x

    let make id =
#if DEBUG
        assertWith (validateMemberId id)
#endif
        Query(id) :> IMemberDetailQuery

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberDetailQueryResultImpl =
        | Success of readModel:IMemberDetailReadModel
        | NotFound

        interface IMemberDetailQueryResult with

            member this.ReadModel
                with get() =
                    match this with
                    | Success(readModel = x) -> x
                    | _ -> invalidOp "Result was not successful"

            member this.IsSuccess
                with get() =
                    match this with
                    | Success(readModel = _) -> true
                    | _ -> false

            member this.IsNotFound
                with get() =
                    match this with
                    | NotFound -> true
                    | _ -> false

    let makeSuccessResult readModel = Success(readModel) :> IMemberDetailQueryResult
    let notFoundResult = NotFound :> IMemberDetailQueryResult

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberDetailQueryHandlerImpl =
        | QueryHandler of context:IFoobleContext

        member private this.Context
            with get() =
                match this with
                | QueryHandler(context = x) -> x

        interface IRequestHandler<IMemberDetailQuery, IMemberDetailQueryResult> with

            member this.Handle(message) =
#if DEBUG
                assertWith (validateRequired message "message" "Message")
#endif

                let readModel =
                    this.Context.GetMember(message.Id, includeDeactivated = false)
                    |> Option.map (fun x ->
                           MemberDetailReadModel.make message.Id x.Username x.Email x.Nickname x.AvatarData
                               x.RegisteredOn x.PasswordChangedOn)

                match readModel with
                | Some(x) -> makeSuccessResult x
                | None -> notFoundResult

    let makeHandler context =
#if DEBUG
        assertWith (validateRequired context "context" "Context")
#endif
        QueryHandler(context) :> IRequestHandler<IMemberDetailQuery, IMemberDetailQueryResult>
