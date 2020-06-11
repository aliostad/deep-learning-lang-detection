package controllers.generic

import defines.PermissionType
import models.base.Accessor
import models.{Group, UserProfile}
import play.api.mvc._
import services.data.{ContentType, DataHelpers}

import scala.concurrent.Future

trait Membership[MT <: Accessor] extends Read[MT] {

  def dataHelpers: DataHelpers

  case class MembershipRequest[A](
    item: MT,
    groups: Seq[(String, String)],
    userOpt: Option[UserProfile],
    request: Request[A]
  ) extends WrappedRequest[A](request)
    with WithOptionalUser

  case class ManageGroupRequest[A](
    item: MT,
    group: Group,
    userOpt: Option[UserProfile],
    request: Request[A]
  ) extends WrappedRequest[A](request)
    with WithOptionalUser

  protected def MembershipAction(id: String)(implicit ct: ContentType[MT]): ActionBuilder[MembershipRequest, AnyContent] =
    WithItemPermissionAction(id, PermissionType.Grant) andThen new CoreActionTransformer[ItemPermissionRequest, MembershipRequest] {
      override protected def transform[A](request: ItemPermissionRequest[A]): Future[MembershipRequest[A]] = {
        dataHelpers.getGroupList.map { groups =>
          // filter out the groups the user already belongs to
          val filteredGroups = groups.filter(t => t._1 != request.item.id).filter {
            case (ident, name) =>
              // if the user is admin, they can add the user to ANY group
              if (request.userOpt.exists(_.isAdmin)) {
                !request.item.groups.map(_.id).contains(ident)
              } else {
                // if not, they can add the user to groups they belong to
                // TODO: Enforce these policies with the permission system!
                // TODO: WRITE TESTS FOR THESE WEIRD BEHAVIOURS!!!
                (!request.item.groups.map(_.id).contains(ident)) &&
                  request.userOpt.exists(_.groups.map(_.id).contains(ident))
              }
          }
          MembershipRequest(request.item, filteredGroups, request.userOpt, request)
        }
      }
    }

  protected def CheckManageGroupAction(id: String, groupId: String)(implicit ct: ContentType[MT]): ActionBuilder[ManageGroupRequest, AnyContent] =
    WithItemPermissionAction(id, PermissionType.Grant) andThen new CoreActionTransformer[ItemPermissionRequest, ManageGroupRequest] {
      override protected def transform[A](request: ItemPermissionRequest[A]): Future[ManageGroupRequest[A]] = {
        implicit val req = request
        userDataApi.get[Group](groupId).map { group =>
          ManageGroupRequest(request.item, group, request.userOpt, request)
        }
      }
    }

  protected def AddToGroupAction(id: String, groupId: String)(implicit ct: ContentType[MT]): ActionBuilder[ItemPermissionRequest, AnyContent] =
    MustBelongTo(groupId) andThen WithItemPermissionAction(id, PermissionType.Grant) andThen new CoreActionTransformer[ItemPermissionRequest, ItemPermissionRequest] {
      override protected def transform[A](request: ItemPermissionRequest[A]): Future[ItemPermissionRequest[A]] = {
        implicit val req = request
        userDataApi.addGroup[Group, MT](groupId, id).map(_ => request)
      }
    }

  protected def RemoveFromGroupAction(id: String, groupId: String)(implicit ct: ContentType[MT]): ActionBuilder[ItemPermissionRequest, AnyContent] =
    MustBelongTo(groupId) andThen WithItemPermissionAction(id, PermissionType.Grant) andThen new CoreActionTransformer[ItemPermissionRequest, ItemPermissionRequest] {
      override protected def transform[A](request: ItemPermissionRequest[A]): Future[ItemPermissionRequest[A]] = {
        implicit val req = request
        userDataApi.removeGroup[Group, MT](groupId, id).map(_ => request)
      }
    }
}
