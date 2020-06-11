namespace Fooble.Core

open Fooble.Common
open Fooble.Persistence
open MediatR
open System

[<RequireQualifiedAccess>]
module internal MemberExistsQuery =

    [<DefaultAugmentation(false)>]
    type private MemberExistsQueryImpl =
        | Query of id:Guid

        interface IMemberExistsQuery with

            member this.Id
                with get() =
                    match this with
                    | Query(id = x) -> x

    let make id =
#if DEBUG
        assertWith (validateMemberId id)
#endif
        Query(id) :> IMemberExistsQuery

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberExistsQueryResultImpl =
        | Success
        | NotFound

        interface IMemberExistsQueryResult with

            member this.IsSuccess
                with get() =
                    match this with
                    | Success -> true
                    | _ -> false

            member this.IsNotFound
                with get() =
                    match this with
                    | NotFound -> true
                    | _ -> false

    let successResult = Success :> IMemberExistsQueryResult
    let notFoundResult = NotFound :> IMemberExistsQueryResult

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberExistsQueryHandlerImpl =
        | QueryHandler of context:IFoobleContext

        member private this.Context
            with get() =
                match this with
                | QueryHandler(context = x) -> x

        interface IRequestHandler<IMemberExistsQuery, IMemberExistsQueryResult> with

            member this.Handle(message) =
#if DEBUG
                assertWith (validateRequired message "message" "Message")
#endif

                match this.Context.ExistsMemberId(message.Id, includeDeactivated = false) with
                | true -> successResult
                | false -> notFoundResult

    let makeHandler context =
#if DEBUG
        assertWith (validateRequired context "context" "Context")
#endif
        QueryHandler(context) :> IRequestHandler<IMemberExistsQuery, IMemberExistsQueryResult>
