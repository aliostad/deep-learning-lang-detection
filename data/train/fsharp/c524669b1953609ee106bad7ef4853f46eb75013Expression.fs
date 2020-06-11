namespace Freya.Machines.Http

open Freya.Core
open Freya.Machines.Http.Machine.Configuration
open Freya.Machines.Http.Machine.Specifications
open Freya.Types.Http

(* Builder

   Computation expression builder for configuring the HTTP Machine, providing a
   simple type-safe syntax and static inference based overloads of single
   functions.

   The builder uses the basic configuration builder defined in Freya.Core, which
   only requires the supply of init and bind functions of the appropriate types
   to implement a type suitable for declarative configuration. *)

type HttpMachineBuilder () =
    inherit ConfigurationBuilder<HttpMachine>
        { Init = HttpMachine.init
          Bind = HttpMachine.bind }

(* Syntax *)

[<AutoOpen>]
module Syntax =

    (* Extensions

       Custom extensions to the HTTP model. *)

    type HttpMachineBuilder with

        /// Defines an extension point for attaching extension components onto
        /// the machine.
        [<CustomOperation ("using", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.Using (m, a) =
            HttpMachine.map (m, Extensions.Components.components_, (Set.union (Components.infer a)))

    (* Properties

       Configuration for common properties of a the HTTP model which may be used by
       multiple elements/components as part. Multiple implementations may rely on
       the same core declarative property of a resource without needing to be aware
       of the existence of other consumers of that property. *)

    (* Request *)

    type HttpMachineBuilder with

        /// Defines the (list of) media types which are acceptable to this
        /// endpoint when receiving content. Received content which is not
        /// acceptable will be handled by `handleUnsupportedMediaType`.
        [<CustomOperation ("acceptableMediaTypes", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.AcceptableMediaTypes (m, a) =
            HttpMachine.set (m, Properties.Request.mediaTypes_, MediaTypes.infer a)

        /// Defines the (list of) HTTP methods this endpoint responds to.
        /// Requests with custom methods not included here will be handled by
        /// `handleMethodNotImplemented`. Requests with core HTTP methods not
        /// included here will be handled by `handleMethodNotAllowed`.
        [<CustomOperation ("methods", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.Methods (m, a) =
            HttpMachine.set (m, Properties.Request.methods_, Methods.infer a)

    (* Representation *)

    type HttpMachineBuilder with

        /// Defines the (list of) character sets available. Used for content
        /// negotiation. Requests where negotiation fails to find an available
        /// representation will be handled by `handleNotAcceptable`.
        [<CustomOperation ("availableCharsets", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.AvailableCharsets (m, a) =
            HttpMachine.set (m, Properties.Representation.charsets_, Charsets.infer a)

        /// Defines the (list of) content codings available. Used for content
        /// negotiation. Requests where negotiation fails to find an available
        /// representation will be handled by `handleNotAcceptable`.
        [<CustomOperation ("availableContentCodings", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.AvailableContentCodings (m, a) =
            HttpMachine.set (m, Properties.Representation.contentCodings_, ContentCodings.infer a)

        /// Defines the (list of) languages available. Used for content
        /// negotiation. Requests where negotiation fails to find an available
        /// representation will be handled by `handleNotAcceptable`.
        [<CustomOperation ("availableLanguages", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.AvailableLanguages (m, a) =
            HttpMachine.set (m, Properties.Representation.languages_, LanguageTags.infer a)

        /// Defines the (list of) media types available. Used for content
        /// negotiation. Requests where negotiation fails to find an available
        /// representation will be handled by `handleNotAcceptable`.
        [<CustomOperation ("availableMediaTypes", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.AvailableMediaTypes (m, a) =
            HttpMachine.set (m, Properties.Representation.mediaTypes_, MediaTypes.infer a)

    (* Resource *)

    type HttpMachineBuilder with

        /// Defines an entity tag (ETag) for the resource. Enables decisions
        /// which deal with comparing entity tags to determine if a resource
        /// has changed since it was last received.
        [<CustomOperation ("entityTag", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.EntityTag (m, a) =
            HttpMachine.set (m, Properties.Resource.entityTag_, EntityTag.infer a)

        /// Defines a last modified timestamp for the resource. Enables
        /// decisions which deal with comparing the last modified timestamp to
        /// determine if a resource has been modified since the last known
        /// modification timestamp.
        [<CustomOperation ("lastModified", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.LastModified (m, a) =
            HttpMachine.set (m, Properties.Resource.lastModified_, DateTime.infer a)

    (* Specifications

       Configuration for discrete specifications used to make up specific
       components used within the HTTP model. The elements structure is flattened
       here to make the application of custom syntax more tractable. *)

    (* Assertions *)

    type HttpMachineBuilder with

        (* Decisions *)

        /// Determines if the service is available and able
        /// to accept requests. When this decision evaluates to false, the
        /// request is handled by `handleServiceUnavailable`.
        [<CustomOperation ("serviceAvailable", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.ServiceAvailable (m, decision) =
            HttpMachine.set (m, Assertions.Decisions.serviceAvailable_, Decision.infer decision)

        /// Determines if the HTTP version of the request is
        /// acceptable to the server. When the HTTP version is not supported,
        /// the request is handled by `handleHttpVersionNotSupported`.
        [<CustomOperation ("httpVersionSupported", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HttpVersion (m, decision) =
            HttpMachine.set (m, Assertions.Decisions.httpVersionSupported_, Decision.infer decision)

        (* Terminals *)

        /// Handles requests where the service has
        /// been determined to be unavailable. See `serviceAvailable`.
        [<CustomOperation ("handleServiceUnavailable", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleServiceUnavailable (m, handler) =
            HttpMachine.set (m, Assertions.Terminals.serviceUnavailable_, Handler.infer handler)

        /// Handles requests where the method is a
        /// non-core HTTP method which the server does not know how to handle.
        /// See `methods`.
        [<CustomOperation ("handleNotImplemented", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleNotImplemented (m, handler) =
            HttpMachine.set (m, Assertions.Terminals.notImplemented_, Handler.infer handler)

        /// Handles requests where the HTTP version
        /// specified cannot be handled by the server.
        /// See `httpVersionSupported`.
        [<CustomOperation ("handleHttpVersionNotSupported", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleHttpVersionNotSupported (m, handler) =
            HttpMachine.set (m, Assertions.Terminals.httpVersionNotSupported_, Handler.infer handler)

    (* Conflict *)

    type HttpMachineBuilder with

        (* Decisions *)

        /// Determines if there has been conflict in the
        /// current state of a resource. If there has been a conflict, the
        /// request is handled by `handleConflict`.
        [<CustomOperation ("conflict", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.Conflict (m, decision) =
            HttpMachine.set (m, Conflict.Decisions.conflict_, Decision.infer decision)

        (* Terminals *)

        /// Handles requests when there has been a
        /// conflict. See `conflict`.
        [<CustomOperation ("handleConflict", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleConflict (m, handler) =
            HttpMachine.set (m, Conflict.Terminals.conflict_, Handler.infer handler)

    (* Content *)

    type HttpMachineBuilder with

        (* Terminals *)

        /// Handles requests with a body where no
        /// content length has been declared.
        [<CustomOperation ("handleLengthRequired", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleLengthRequired (m, handler) =
            HttpMachine.set (m, Content.Terminals.lengthRequired_, Handler.infer handler)

        [<CustomOperation ("handleUnsupportedMediaType", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleUnsupportedMediaType (m, handler) =
            HttpMachine.set (m, Content.Terminals.unsupportedMediaType_, Handler.infer handler)

    (* Existence *)

    type HttpMachineBuilder with

        (* Decisions *)

        /// Determines if a resource exists. A resource that
        /// does not exist may have moved, be missing, or be gone.
        /// See `gone`, `permanentlyMoved`, `temporarilyMoved`. Requests which
        /// are missing but have not been moved are handled by `handleNotFound`.
        [<CustomOperation ("exists", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.Exists (m, decision) =
            HttpMachine.set (m, Existence.Decisions.exists_, Decision.infer decision)

    (* Fallback *)

    type HttpMachineBuilder with

        (* Terminals *)

        /// Handles all requests where the server
        /// has allowed the method on the request, but for which the server has
        /// not defined a handler.
        [<CustomOperation ("handleFallback", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleFallback (m, handler) =
            HttpMachine.set (m, Fallback.Terminals.fallback_, Handler.infer handler)

    (* Negotiations *)

    type HttpMachineBuilder with

        (* Terminals *)

        /// Defines a handler which reponds to requests where content
        /// negotiation has been unable to find a representation which would be
        /// acceptable to the client. See `availableCharsets`,
        /// `availableContentCodings`, `availableMediaTypes`,
        /// and `availableLanguages`.
        [<CustomOperation ("handleNotAcceptable", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleNotAcceptable (m, handler) =
            HttpMachine.set (m, Negotiations.Terminals.notAcceptable_, Handler.infer handler)

    (* Operations *)

    type HttpMachineBuilder with

        (* Decisions *)

        /// Determines whether the server has completed
        /// action on the request. If not completed, the request may be handled
        /// later, but is not guaranteed to succeed. A request that has not
        /// been completed is handled by `handleAccepted`.
        [<CustomOperation ("completed", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.Completed (m, decision) =
            HttpMachine.set (m, Operation.Decisions.completed_, Decision.infer decision)

        (* Operations *)

        /// Handles requests with the DELETE method.
        [<CustomOperation ("doDelete", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.DoDelete (m, a) =
            HttpMachine.set (m, (Operation.Decisions.operationMethod_ DELETE), Operation.infer a)

        /// Handles requests with the POST method.
        [<CustomOperation ("doPost", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.DoPost (m, a) =
            HttpMachine.set (m, (Operation.Decisions.operationMethod_ POST), Operation.infer a)

        /// Handles requests with the PUT method.
        [<CustomOperation ("doPut", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.DoPut (m, a) =
            HttpMachine.set (m, (Operation.Decisions.operationMethod_ PUT), Operation.infer a)

        (* Terminals *)

        /// Handles requests that have been
        /// accepted for asynchronous processing. See `completed`.
        [<CustomOperation ("handleAccepted", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleAccepted (m, handler) =
            HttpMachine.set (m, Operation.Terminals.accepted_, Handler.infer handler)

        /// Handles requests where there has been
        /// an internal server error.
        [<CustomOperation ("handleInternalServerError", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleInternalServerError (m, handler) =
            HttpMachine.set (m, Operation.Terminals.internalServerError_, Handler.infer handler)

    (* Permissions *)

    type HttpMachineBuilder with

        (* Decisions *)

        /// Determines whether the request has valid
        /// authentication credentials for the target. Requests which do not
        /// include valid authentication credentials are handled by
        /// `handleUnauthorized`.
        [<CustomOperation ("authorized", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.Authorized (m, decision) =
            HttpMachine.set (m, Permissions.Decisions.authorized_, Decision.infer decision)

        /// Determines whether the server understood the
        /// request, but is refusing access to the requested resource. Requests
        /// which are not allowed are handled by `handleForbidden`.
        [<CustomOperation ("allowed", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.Allowed (m, decision) =
            HttpMachine.set (m, Permissions.Decisions.allowed_, Decision.infer decision)

        (* Terminals *)

        /// Handles requests where no valid
        /// authentication credentials were presented to the server.
        /// See `Authorized`.
        [<CustomOperation ("handleUnauthorized", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleUnauthorized (m, handler) =
            HttpMachine.set (m, Permissions.Terminals.unauthorized_, Handler.infer handler)

        /// Handles requests where the client has
        /// been refused access. See `allowed`.
        [<CustomOperation ("handleForbidden", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleForbidden (m, handler) =
            HttpMachine.set (m, Permissions.Terminals.forbidden_, Handler.infer handler)

    (* Preconditions *)

    type HttpMachineBuilder with

        (* Terminals *)

        /// Handles requests where a header condition provided by the client
        /// evaluates to false. See `entityTag` and `lastModified`.
        [<CustomOperation ("handlePreconditionFailed", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandlePreconditionFailed (m, handler) =
            HttpMachine.set (m, Preconditions.Shared.Terminals.preconditionFailed_, Handler.infer handler)

    (* Responses.Common *)

    type HttpMachineBuilder with

        (* Decisions *)

        /// Determines whether or not the body of the response contains any
        /// content. Requests which result in no returned content are handled
        /// by `handleNoContent`.
        [<CustomOperation ("noContent", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.NoContent (m, decision) =
            HttpMachine.set (m, Responses.Common.Decisions.noContent_, Decision.infer decision)

        (* Terminals *)

        /// Handles common requests where the response has no content.
        /// See `noContent`.
        [<CustomOperation ("handleNoContent", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleNoContent (m, handler) =
            HttpMachine.set (m, Responses.Common.Terminals.noContent_, Handler.infer handler)

        /// Handles common requests where the response has content.
        [<CustomOperation ("handleOk", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleOk (m, handler) =
            HttpMachine.set (m, Responses.Common.Terminals.ok_, Handler.infer handler)

    (* Responses.Created *)

    type HttpMachineBuilder with

        (* Decisions *)

        /// Determines whether or not the request has resulted in the creation
        /// of an entity. Requests which result in the creation of an entity
        /// are handled by `handleCreated`.
        [<CustomOperation ("created", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.Created (m, decision) =
            HttpMachine.set (m, Responses.Created.Decisions.created_, Decision.infer decision)

        (* Terminals *)

        /// Handles requests where the server has created an entity.
        /// See `created`.
        [<CustomOperation ("handleCreated", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleCreated (m, handler) =
            HttpMachine.set (m, Responses.Created.Terminals.created_, Handler.infer handler)

    (* Responses.Missing *)

    type HttpMachineBuilder with

        (* Terminals *)

        /// Handles requests where the requested resource is missing.
        /// See `exists`.
        [<CustomOperation ("handleNotFound", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleNotFound (m, handler) =
            HttpMachine.set (m, Responses.Missing.Terminals.notFound_, Handler.infer handler)

    (* Responses.Moved *)

    type HttpMachineBuilder with

        (* Decisions *)

        /// Determines whether the requested resource once existed but is now
        /// permanently missing. Resources which are permanently missing are
        /// handled by `handleGone`.
        [<CustomOperation ("gone", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.Gone (m, decision) =
            HttpMachine.set (m, Responses.Moved.Decisions.gone_, Decision.infer decision)

        /// Determines whether the requested resource is missing because it
        /// has been permanently moved. Resources that have been permanently
        /// moved are handled by `handleMovedPermanently`.
        [<CustomOperation ("movedPermanently", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.MovedPermanently (m, decision) =
            HttpMachine.set (m, Responses.Moved.Decisions.movedPermanently_, Decision.infer decision)

        /// Determines whether the requested resource is missing because it
        /// has been permanently moved. Resources that have been permanently
        /// moved are handled by `handleMovedTemporarily`.
        [<CustomOperation ("movedTemporarily", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.MovedTemporarily (m, decision) =
            HttpMachine.set (m, Responses.Moved.Decisions.movedTemporarily_, Decision.infer decision)

        (* Terminals *)

        /// Handles requests where the requested resource previously existed,
        /// but is now permanently missing. See `gone`.
        [<CustomOperation ("handleGone", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleGone (m, handler) =
            HttpMachine.set (m, Responses.Moved.Terminals.gone_, Handler.infer handler)

        /// Handles requests where the requested resource has been moved
        /// permanently. See `movedPermanently`.
        [<CustomOperation ("handleMovedPermanently", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleMovedPermanently (m, handler) =
            HttpMachine.set (m, Responses.Moved.Terminals.movedPermanently_, Handler.infer handler)

        /// Handles requests where the requested resource has been moved
        /// temporarily. See `movedTemporarily`.
        [<CustomOperation ("handleTemporaryRedirect", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleTemporaryRedirect (m, handler) =
            HttpMachine.set (m, Responses.Moved.Terminals.temporaryRedirect_, Handler.infer handler)

    (* Responses.Options *)

    type HttpMachineBuilder with

        (* Terminals *)

        /// Handles requests with the OPTIONS method.
        [<CustomOperation ("handleOptions", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleOptions (m, handler) =
            HttpMachine.set (m, Responses.Options.Terminals.options_, Handler.infer handler)

    (* Responses.Other *)

    type HttpMachineBuilder with

        (* Decisions *)

        [<CustomOperation ("found", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.Found (m, decision) =
            HttpMachine.set (m, Responses.Other.Decisions.found_, Decision.infer decision)

        [<CustomOperation ("multipleChoices", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.MultipleChoices (m, decision) =
            HttpMachine.set (m, Responses.Other.Decisions.multipleChoices_, Decision.infer decision)

        [<CustomOperation ("seeOther", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.SeeOther (m, decision) =
            HttpMachine.set (m, Responses.Other.Decisions.seeOther_, Decision.infer decision)

        (* Terminals *)

        [<CustomOperation ("handleFound", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleFound (m, handler) =
            HttpMachine.set (m, Responses.Other.Terminals.found_, Handler.infer handler)

        [<CustomOperation ("handleMultipleChoices", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleMultipleChoices (m, handler) =
            HttpMachine.set (m, Responses.Other.Terminals.multipleChoices_, Handler.infer handler)

        [<CustomOperation ("handleSeeOther", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleSeeOther (m, handler) =
            HttpMachine.set (m, Responses.Other.Terminals.seeOther_, Handler.infer handler)

    (* Validations *)

    type HttpMachineBuilder with

        (* Decisions *)

        [<CustomOperation ("expectationMet", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.ExpectationMet (m, decision) =
            HttpMachine.set (m, Validations.Decisions.expectationMet_, Decision.infer decision)

        [<CustomOperation ("uriTooLong", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.UriTooLong (m, decision) =
            HttpMachine.set (m, Validations.Decisions.uriTooLong_, Decision.infer decision)

        [<CustomOperation ("badRequest", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.BadRequest (m, decision) =
            HttpMachine.set (m, Validations.Decisions.badRequest_, Decision.infer decision)

        (* Terminals *)

        [<CustomOperation ("handleExpectationFailed", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleExpectationFailed (m, handler) =
            HttpMachine.set (m, Validations.Terminals.expectationFailed_, Handler.infer handler)

        [<CustomOperation ("handleMethodNotAllowed", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleMethodNotAllowed (m, handler) =
            HttpMachine.set (m, Validations.Terminals.methodNotAllowed_, Handler.infer handler)

        [<CustomOperation ("handleUriTooLong", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleUriTooLong (m, handler) =
            HttpMachine.set (m, Validations.Terminals.uriTooLong_, Handler.infer handler)

        [<CustomOperation ("handleBadRequest", MaintainsVariableSpaceUsingBind = true)>]
        member inline __.HandleBadRequest (m, handler) =
            HttpMachine.set (m, Validations.Terminals.badRequest_, Handler.infer handler)

(* Builder

   The instance of HttpMachineBuilder which will be used to provide the
   custom computation expression syntax. The instance is aliased as freyaMachine
   for backwards compatibility with earlier versions of Freya which assumed a
   single machine implementation in perpetuity. *)

[<AutoOpen>]
module Builder =

    let freyaHttpMachine =
        HttpMachineBuilder ()

    let freyaMachine =
        freyaHttpMachine
