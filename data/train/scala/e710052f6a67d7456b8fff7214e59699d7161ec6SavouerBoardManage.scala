package models.savouerboard

import java.sql.Date
import java.util
import java.util.UUID
import java.util.concurrent.Future

import com.datastax.driver.core.Row
import play.api.libs.json.Json._
import com.datastax.driver.core.Row
import play.api.libs.json.{Json, JsValue, Writes}

import scala.collection.mutable.ArrayBuffer
import scala.concurrent.ExecutionContext


/**
 * Created by huxiangtao on 15-1-4.
 */
/**
 *  SavouerBoardManage 实体对象
 * @param id  Long,帖子ID
 * @param name String,帖子名称
 * @param description String,帖子描述
 * @param managerUid Long,收录者ID
 * @param managerName String,收录者姓名
 * @param status  Int,状态
 * @param createdAt Date,发表时间
 */

case class SavouerBoardManageBoardManage(
          id:UUID,
          name:String,
          description:String,
          managerUid:Long,
          managerName:String,
          createdAt:Date,
          category: Int = 0
      )

object SavouerBoardManageBoardManage {

  val client = SimpleClient.client

  val statusMap: Map[String, String] = Map("10" -> "新增","20" -> "")

  val categoryMap: Map[String, String] = Map("1" -> "设计","2" -> "科技","3" -> "人文","4" -> "影视","5" -> "专辑")

  //封装写入json对象
  implicit val implicitSavouerBoardManageWrites = new Writes[SavouerBoardManage] {
    def writes(savouerboard: SavouerBoardManage): JsValue = {
      if(savouerboard!=null){
        Json.obj(
          "id" -> savouerboard.id.toString,
          "name" -> savouerboard.name,
          "description" -> savouerboard.description,
          "managerUid" -> savouerboard.managerUid.toString,
          "managerName" -> savouerboard.managerName,
          "status" -> savouerboard.status,
          "createdAt" -> savouerboard.createdAt.toString,
          "category" -> savouerboard.category,
          "categoryName" -> categoryMap.getOrElse(savouerboard.category.toString, "").toString
        )
      }else{
        Json.obj()
      }
    }
  }

  def SavouerBoardManage(row:Row):SavouerBoardManage = {
    if(row == null) {
      null
    } else {
      SavouerBoardManage(
        row.getUUID("id"),
        row.getString("name"),
        row.getString("description"),
        row.getLong("manager_uid"),
        row.getString("manager_name"),
        row.getString("business_target"),
        row.getString("actual_reach"),
        row.getString("reason"),
        row.getString("improvement"),
        List[ProjectStage](),//for stages
        row.getFloat("human_resources2"),
        row.getInt("priority"),
        row.getInt("status"),
        row.getString("version"),
        row.getString("savouerboard_url"),
        row.getString("svn_url"),
        row.getString("redmine_url"),
        row.getDate("created_at"),
        row.getInt("type"),
        Seq[MeetingInfo](),
        row.getInt("category"),
        row.getInt("human_resources")
      )
    }
  }

  def insert(savouerboard: SavouerBoardManage)(implicit ctxt: ExecutionContext):Future[UUID]

  def update(savouerboard: SavouerBoardManage)(implicit ctxt: ExecutionContext)

  def delete(savouerboardId:UUID)

  def select(savouerboardId:UUID): Option[SavouerBoardManage]

  def selectList(savouerboardId: UUID): List[SavouerBoardManage]

  def selectAll(): List[SavouerBoardManage]

}