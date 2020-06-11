namespace Fooble.Core

open Fooble.Common
open Fooble.Persistence
open Fooble.Presentation
open MediatR
open System

[<RequireQualifiedAccess>]
module internal MemberEmailQuery =

    [<DefaultAugmentation(false)>]
    type private MemberEmailQueryImpl =
        | Query of id:Guid

        interface IMemberEmailQuery with

            member this.Id
                with get() =
                    match this with
                    | Query(id = x) -> x

    let make id =
#if DEBUG
        assertWith (validateMemberId id)
#endif
        Query(id) :> IMemberEmailQuery

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberEmailQueryResultImpl =
        | Success of viewModel:IMemberChangeEmailViewModel
        | NotFound

        interface IMemberEmailQueryResult with

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

    let makeSuccessResult readModel = Success(readModel) :> IMemberEmailQueryResult
    let notFoundResult = NotFound :> IMemberEmailQueryResult

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberEmailQueryHandlerImpl =
        | QueryHandler of context:IFoobleContext

        member private this.Context
            with get() =
                match this with
                | QueryHandler(context = x) -> x

        interface IRequestHandler<IMemberEmailQuery, IMemberEmailQueryResult> with

            member this.Handle(message) =
#if DEBUG
                assertWith (validateRequired message "message" "Message")
#endif

                let viewModel =
                    this.Context.GetMember(message.Id, includeDeactivated = false)
                    |> Option.map (fun x -> MemberChangeEmailViewModel.make message.Id String.Empty x.Email)

                match viewModel with
                | Some(x) -> makeSuccessResult x
                | None -> notFoundResult

    let makeHandler context =
#if DEBUG
        assertWith (validateRequired context "context" "Context")
#endif
        QueryHandler(context) :> IRequestHandler<IMemberEmailQuery, IMemberEmailQueryResult>
