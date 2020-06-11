package com.github.cupenya.auth.service.persistence

import com.github.cupenya.auth.service.Logging
import org.mongodb.scala.MongoDatabase
import org.mongodb.scala.bson.{BsonArray, BsonDocument, BsonString}

import scala.concurrent.{ExecutionContext, Future}
import org.mongodb.scala.model.Filters._
import spray.json.DefaultJsonProtocol

object RoleDao extends RoleDao

case class Role(
                 id: String,
                 name: String,
                 description: Option[String],
                 permissionIds: List[String]
               ) extends RoleModel

sealed trait RoleModel

object RoleModel extends DefaultJsonProtocol {
  implicit val RoleFormat = jsonFormat4(Role)
}

trait RoleService {
  private val roleDao = RoleDao

  private val ADMIN_ROLE_ID = "admin"

  // TODO: persistence
  private val ADMIN_PERMISSIONS = List(
    "admin",
    "scenario.create",
    "user.manage",
    "user.role.manage",
    "user.group.manage",
    "agent.deployment.manage",
    "agent.descriptor.manage",
    "feature.requestView",
    "feature.requestView.manage",
    "feature.requestView.analytics",
    "feature.requestView.requestHistory",
    "feature.requestView.showTestDuration",
    "feature.requestView.outOfDataNotification",
    "feature.requestView.enableSubscribe",
    "feature.requestView.enableAdvancedControls",
    "feature.newVersion.notification",
    "feature.teams.notification",
    "feature.uploadData",
    "feature.applicationLink",
    "feature.subRequestReporting",
    "feature.workLog",
    "feature.classification",
    "feature.editor",
    "feature.editor.indicator",
    "feature.editor.redeployment",
    "feature.reporting",
    "feature.reporting.manage",
    "feature.reporting.landing",
    "feature.reporting.share",
    "feature.reporting.export.excel",
    "feature.reporting.filters",
    "feature.missions",
    "feature.monitor",
    "feature.settings",
    "action.zendesk.linkedTicketUpdate",
    "action.zendesk.macroRecommendation",
    "action.zendesk.ticketStatusUpdate",
    "team.create"
  )

  def getPermissions(roleIds: List[String])(implicit ec: ExecutionContext, db: MongoDatabase): Future[List[String]] =
    if (roleIds.contains(ADMIN_ROLE_ID)) Future.successful(ADMIN_PERMISSIONS) else roleDao.findByIds(roleIds).map(_.flatMap(_.permissionIds))
}

object RoleService extends RoleService

trait RoleDao extends MongoDao with Logging {
  override def collectionName: String = "Role"

  def findByIds(roleIds: List[String])(implicit ec: ExecutionContext, db: MongoDatabase): Future[List[Role]] = {
    find[Role](BsonDocument(Map("_id" -> BsonDocument("$in" -> roleIds)))).map(_.toList)
  }
}