package writes

import models.WXUserInfo
import play.api.libs.functional.syntax._
import play.api.libs.json.{JsPath, Writes}

/**
  * Created by Damon on 16/5/26.
  */
trait WXWrites {

  implicit val wxUserInfoWrites: Writes[WXUserInfo] = (
    (JsPath \ "subscribe").write[Int] and
      (JsPath \ "openid").write[String] and
      (JsPath \ "nickname").write[String] and
      (JsPath \ "sex").write[Int] and
      (JsPath \ "language").write[String] and
      (JsPath \ "city").write[String] and
      (JsPath \ "province").write[String] and
      (JsPath \ "country").write[String] and
      (JsPath \ "headimgurl").write[String] and
      (JsPath \ "subscribe_time").write[Long] and
      (JsPath \ "remark").write[String] and
      (JsPath \ "groupid").write[Int] and
      (JsPath \ "tagid_list").write[Seq[Int]]
    )(unlift(WXUserInfo.unapply))

}
