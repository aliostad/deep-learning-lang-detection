namespace Fooble.Core

open Fooble.Common
open Fooble.Persistence
open Fooble.Presentation
open MediatR
open System

[<RequireQualifiedAccess>]
module internal MemberUsernameQuery =

    [<DefaultAugmentation(false)>]
    type private MemberUsernameQueryImpl =
        | Query of id:Guid

        interface IMemberUsernameQuery with

            member this.Id
                with get() =
                    match this with
                    | Query(id = x) -> x

    let make id =
#if DEBUG
        assertWith (validateMemberId id)
#endif
        Query(id) :> IMemberUsernameQuery

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberUsernameQueryResultImpl =
        | Success of viewModel:IMemberChangeUsernameViewModel
        | NotFound

        interface IMemberUsernameQueryResult with

            member this.ViewModel
                with get() =
                    match this with
                    | Success(viewModel = x) -> x
                    | _ -> invalidOp "Result was not successful"

            member this.IsSuccess
                with get() =
                    match this with
                    | Success(viewModel = _) -> true
                    | _ -> false

            member this.IsNotFound
                with get() =
                    match this with
                    | NotFound -> true
                    | _ -> false

    let makeSuccessResult readModel = Success(readModel) :> IMemberUsernameQueryResult
    let notFoundResult = NotFound :> IMemberUsernameQueryResult

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberUsernameQueryHandlerImpl =
        | QueryHandler of context:IFoobleContext

        member private this.Context
            with get() =
                match this with
                | QueryHandler(context = x) -> x

        interface IRequestHandler<IMemberUsernameQuery, IMemberUsernameQueryResult> with

            member this.Handle(message) =
#if DEBUG
                assertWith (validateRequired message "message" "Message")
#endif

                let viewModel =
                    this.Context.GetMember(message.Id, includeDeactivated = false)
                    |> Option.map (fun x -> MemberChangeUsernameViewModel.make message.Id String.Empty x.Username)

                match viewModel with
                | Some(x) -> makeSuccessResult x
                | None -> notFoundResult

    let makeHandler context =
#if DEBUG
        assertWith (validateRequired context "context" "Context")
#endif
        QueryHandler(context) :> IRequestHandler<IMemberUsernameQuery, IMemberUsernameQueryResult>
