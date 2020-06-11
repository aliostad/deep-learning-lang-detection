package controllers

import models.buildActions.{BuildAction, BuildParametersCategory}
import models.configuration._
import models.magicMerge.MagicMergeResult
import models._
import models.cycles.{CycleConstants, TestCategory}
import org.joda.time.DateTime
import play.api.libs.functional.syntax._
import play.api.libs.json.Json.JsValueWrapper
import play.api.libs.json.Writes._
import play.api.libs.json._

object Formats {
  implicit val mapWrites = new Writes[Map[TestCategory, List[String]]] {
    def writes(map: Map[TestCategory, List[String]]): JsValue =
      Json.obj(map.map { case (category, list) =>
        val ret: (String, JsValueWrapper) = category.name -> JsArray(list.map(JsString))
        ret
      }.toSeq: _*)
  }

  implicit val mapReads = new Reads[Map[TestCategory, List[String]]] {
    def reads(jv: JsValue): JsResult[Map[TestCategory, List[String]]] =
      JsSuccess(jv.as[Map[String, List[String]]].map { case (name, values) =>
        CycleConstants.allTestCategories(name) -> values
      })
  }

  implicit val mapFormat = Format(mapReads, mapWrites)


  implicit val deployConfig = Json.format[DeployConfig]
  implicit val cycleParameters = Json.format[CycleParameters]
  implicit val cycleConfig = Json.format[CycleConfig]
  implicit val buildConfig = Json.format[BuildConfig]
  implicit val buildBoardConfig: Format[BuildBoardConfig] = Json.format[BuildBoardConfig]


  implicit val artifactFormat = Json.format[Artifact]
  implicit val testCaseWrite = Json.format[TestCase]
  implicit val testCasePackageWrite = Json.format[TestCasePackage]
  implicit var buildNodeWrite: Writes[BuildNode] = null

  buildNodeWrite = (
    (__ \ "id").write[String] ~
      (__ \ "name").write[String] ~
      (__ \ "runName").write[String] ~
      (__ \ "number").write[Int] ~
      (__ \ "status").writeNullable[String] ~
      (__ \ "statusUrl").write[String] ~
      (__ \ "artifacts").write(list(artifactFormat)) ~
      (__ \ "timestamp").write[DateTime] ~
      (__ \ "timestampEnd").writeNullable[DateTime] ~
      (__ \ "rerun").writeNullable[Boolean] ~
      (__ \ "isUnstable").writeNullable[Boolean] ~
      (__ \ "children").lazyWrite(list(buildNodeWrite)) ~
      (__ \ "testResults").write(list(testCasePackageWrite))
    ) ((node: BuildNode) => BuildNode.unapply(node.copy(status = Some(node.buildStatus.name.toUpperCase))).get)

  implicit val commitWrite: Writes[Commit] = Json.writes[Commit]

  val buildWrite: Writes[Build] =
    (
      (__ \ "number").write[Int] ~
        (__ \ "branch").write[String] ~
        (__ \ "status").writeNullable[String] ~
        (__ \ "timestamp").write[DateTime] ~
        (__ \ "timestampEnd").writeNullable[DateTime] ~
        (__ \ "toggled").write[Boolean] ~
        (__ \ "commits").write(list(commitWrite)) ~
        (__ \ "ref").writeNullable[String] ~
        (__ \ "initiator").writeNullable[String] ~
        (__ \ "description").writeNullable[String] ~
        (__ \ "pullRequestId").writeNullable[Int] ~
        (__ \ "name").write[String] ~
        (__ \ "artifacts").write(list[Artifact]) ~
        (__ \ "activityType").write[String] ~
        (__ \ "node").writeNullable[BuildNode] ~
        (__ \ "pendingReruns").write(list[String])
      ) ((b: Build) => Build.unapply(b.copy(status = Some(b.buildStatus.name.toUpperCase),
      timestampEnd = b.node.flatMap(_.timestampEnd).orElse(b.timestampEnd))).get)


  implicit val mergeResultWrite = Json.writes[MergeResult]
  implicit val buildParametersCategoryWrite = Json.writes[BuildParametersCategory]


  implicit val buildActionWrite = ((__ \ "name").write[String] ~
    (__ \ "pullRequestId").writeNullable[Int] ~
    (__ \ "branchId").writeNullable[String] ~
    (__ \ "cycleName").write[String] ~
    (__ \ "action").write[String] ~
    (__ \ "buildParametersCategories").write(list(buildParametersCategoryWrite))) (unlift(BuildAction.unapply))

  implicit val entityAssignment = Json.writes[Assignment]
  implicit val entityStateWrite = Json.writes[EntityState]
  implicit val entityWrite = Json.writes[Entity]

  implicit val statusWrites = Json.writes[PullRequestStatus]

  val prWrite = Json.writes[PullRequest]

  implicit val activityEntryWrites = new Writes[ActivityEntry] {
    override def writes(o: ActivityEntry): JsValue = o match {
      case b: Build => buildWrite.writes(b)
      case b: PullRequest => prWrite.writes(b)
      case c: Commit => commitWrite.writes(c)
    }
  }

  implicit val branchWrite = Json.writes[Branch]

  implicit val magicMergeResultWrite: OWrites[MagicMergeResult] = (
    (__ \ "message").write[String] ~
      (__ \ "merged").write[Boolean] ~
      (__ \ "deleted").write[Boolean] ~
      (__ \ "closed").write[Boolean]
    ) ((m: MagicMergeResult) => (m.description, m.merged, m.deleted, m.closed))
}
