namespace Fooble.Core

open Fooble.Common
open Fooble.Persistence
open Fooble.Presentation
open MediatR

[<RequireQualifiedAccess>]
module internal MemberListQuery =

    [<DefaultAugmentation(false)>]
    type private MemberListQueryImpl =
        | Query

        interface IMemberListQuery

    let make () = Query :> IMemberListQuery

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberListQueryResultImpl =
        | Success of readModel:IMemberListReadModel
        | NotFound

        interface IMemberListQueryResult with

            member this.ReadModel
                with get() =
                    match this with
                    | Success(readModel = x) -> x
                    | NotFound -> invalidOp "Result was not successful"

            member this.IsSuccess
                with get() =
                    match this with
                    | Success(readModel = _) -> true
                    | NotFound -> false

            member this.IsNotFound
                with get() =
                    match this with
                    | Success(readModel = _) -> false
                    | NotFound -> true

    let makeSuccessResult readModel = Success(readModel) :> IMemberListQueryResult
    let notFoundResult = NotFound :> IMemberListQueryResult

    [<DefaultAugmentation(false)>]
    [<NoComparison>]
    type private MemberListQueryHandlerImpl =
        | QueryHandler of context:IFoobleContext

        member private this.Context
            with get() =
                match this with
                | QueryHandler(context = x) -> x

        interface IRequestHandler<IMemberListQuery, IMemberListQueryResult> with

            member this.Handle(message) =
#if DEBUG
                assertWith (validateRequired message "message" "Message")
#endif

                let members =
                    this.Context.GetMembers(includeDeactivated = false)
                    |> List.map (fun x -> MemberListReadModel.makeItem x.Id x.Nickname x.AvatarData)

                match members with
                | [] -> notFoundResult
                | xs ->

                let memberCount = Seq.length members

                Seq.ofList xs
                |> fun x -> MemberListReadModel.make x memberCount
                |> makeSuccessResult

    let makeHandler context =
#if DEBUG
        assertWith (validateRequired context "context" "Context")
#endif
        QueryHandler(context) :> IRequestHandler<IMemberListQuery, IMemberListQueryResult>
