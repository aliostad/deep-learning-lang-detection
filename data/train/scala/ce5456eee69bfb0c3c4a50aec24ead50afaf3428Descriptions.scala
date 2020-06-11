package controllers.generic

import defines.PermissionType
import models.UserProfile
import models.base._
import play.api.data.Form
import play.api.mvc._
import services.data.{ContentType, ValidationError, Writable}

import scala.concurrent.Future
import scala.concurrent.Future.{successful => immediate}

/**
  * Controller trait for creating, updating, and deleting auxiliary descriptions
  * for entities that can be multiply described.
  */
trait Descriptions[D <: Description with Persistable, T <: Model with Described[D], MT <: MetaModel[T]] extends Write {

  this: Read[MT] =>

  case class ManageDescriptionRequest[A](
    item: MT,
    formOrDescription: Either[Form[D], D],
    userOpt: Option[UserProfile],
    request: Request[A]
  ) extends WrappedRequest[A](request)
    with WithOptionalUser

  case class DeleteDescriptionRequest[A](
    item: MT,
    description: D,
    userOpt: Option[UserProfile],
    request: Request[A]
  ) extends WrappedRequest[A](request)
    with WithOptionalUser


  protected def CreateDescriptionAction(id: String, form: Form[D])(
    implicit fmt: Writable[D], ct: ContentType[MT]): ActionBuilder[ManageDescriptionRequest, AnyContent] =
    WithItemPermissionAction(id, PermissionType.Update) andThen new CoreActionTransformer[ItemPermissionRequest, ManageDescriptionRequest] {
      override protected def transform[A](request: ItemPermissionRequest[A]): Future[ManageDescriptionRequest[A]] = {
        implicit val req = request
        form.bindFromRequest.fold(
          ef => immediate(ManageDescriptionRequest(request.item, Left(ef), request.userOpt, request)),
          desc => userDataApi.createDescription(id, desc, logMsg = getLogMessage).map { updated =>
            ManageDescriptionRequest(request.item, Right(updated), request.userOpt, request)
          } recover {
            case ValidationError(errorSet) =>
              val badForm = desc.getFormErrors(errorSet, form.fill(desc))
              ManageDescriptionRequest(request.item, Left(badForm), request.userOpt, request)
          }
        )
      }
    }

  protected def UpdateDescriptionAction(id: String, did: String, form: Form[D])(
    implicit fmt: Writable[D], ct: ContentType[MT]): ActionBuilder[ManageDescriptionRequest, AnyContent] =
    WithItemPermissionAction(id, PermissionType.Update) andThen new CoreActionTransformer[ItemPermissionRequest, ManageDescriptionRequest] {
      override protected def transform[A](request: ItemPermissionRequest[A]): Future[ManageDescriptionRequest[A]] = {
        implicit val req = request
        form.bindFromRequest.fold(
          ef => immediate(ManageDescriptionRequest(request.item, Left(ef), request.userOpt, request)),
          desc => userDataApi.updateDescription(id, did, desc, logMsg = getLogMessage).map { updated =>
            ManageDescriptionRequest(request.item, Right(updated), request.userOpt, request)
          } recover {
            case ValidationError(errorSet) =>
              val badForm = desc.getFormErrors(errorSet, form.fill(desc))
              ManageDescriptionRequest(request.item, Left(badForm), request.userOpt, request)
          }
        )
      }
    }

  protected def WithDescriptionAction(id: String, did: String)(
    implicit ct: ContentType[MT]): ActionBuilder[DeleteDescriptionRequest, AnyContent] =
    WithItemPermissionAction(id, PermissionType.Update) andThen new CoreActionRefiner[ItemPermissionRequest, DeleteDescriptionRequest] {
      override protected def refine[A](request: ItemPermissionRequest[A]): Future[Either[Result, DeleteDescriptionRequest[A]]] = {
        request.item.model.description(did) match {
          case Some(d) => immediate(Right(DeleteDescriptionRequest(request.item, d, request.userOpt, request)))
          case None => notFoundError(request).map(r => Left(r))
        }
      }
    }

  protected def DeleteDescriptionAction(id: String, did: String)(implicit ct: ContentType[MT]): ActionBuilder[OptionalUserRequest, AnyContent] =
    WithItemPermissionAction(id, PermissionType.Update) andThen new CoreActionTransformer[ItemPermissionRequest, OptionalUserRequest] {
      override protected def transform[A](request: ItemPermissionRequest[A]): Future[OptionalUserRequest[A]] = {
        implicit val req = request
        userDataApi.deleteDescription(id, did, logMsg = getLogMessage).map { _ =>
          OptionalUserRequest(request.userOpt, request)
        }
      }
    }
}

