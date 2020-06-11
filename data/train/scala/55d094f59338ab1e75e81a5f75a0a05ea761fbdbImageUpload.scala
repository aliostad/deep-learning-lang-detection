package controllers

import javax.inject.Inject

import play.api.Logger
import play.api.cache.CacheApi
import play.api.libs.json._
import play.api.libs.functional.syntax._
import play.api.libs.ws.WSClient
import play.api.mvc.{Results, Action, Controller}
import utils.Encryption
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

/**
 * Created by leo on 15-12-1.
 */
class ImageUpload @Inject()(ws: WSClient, cache: CacheApi) extends Controller {
  private lazy val log = Logger(this.getClass)

  private lazy val ACCESS_KEY = Application.QINIU_ACCESS_KEY
  private lazy val SECRET_KEY = Application.QINIU_SECRET_KEY
  private lazy val BUCKET_NAME = Application.QINIU_BUCKET_NAME

  private lazy val RETURN_BODY_JSON = "{\"name\": $(key),\"size\": $(fsize),\"w\": $(imageInfo.width),\"h\": $(imageInfo.height),\"hash\": $(etag)}"
  private lazy val MANAGE_HOST = "http://rs.qiniu.com"
  private lazy val MANAGE_DELETE_PATH_PREFIX = "/delete/"
  private lazy val MANAGE_DELETE_REQUEST_PREFIX = "QBox "

  implicit val uploadPolicyWrites: Writes[PutPolicy] = (
    (JsPath \ "scope").write[String] and
      (JsPath \ "deadLine").write[Long] and
      (JsPath \ "returnBody").write[String]
    ) (unlift(PutPolicy.unapply))

  private def getPutPolicy(imageName: String = ""): String = {
    val scope = imageName.isEmpty match {
      case true => BUCKET_NAME
      case false => BUCKET_NAME + ":" + imageName
    }
    val deadline = (System.currentTimeMillis) / 1000 + 3600
    val putPolicy = PutPolicy(scope, deadline, RETURN_BODY_JSON)
    Json.toJson(putPolicy).toString
  }

  private def getPutPolicyEncode(imageName: String = "") = Encryption.urlSafe(Encryption.encodeByBase64(getPutPolicy(imageName)))

  private def sign(putPolicyEncode: String) = Encryption.urlSafe(Encryption.encodeByHmacSha1AndthenBase64(putPolicyEncode, SECRET_KEY))

  def getUploadToken(imageName: String = "") = Action.async {
    val putPolicyEncode = getPutPolicyEncode(imageName)
    val token = ACCESS_KEY + ":" + sign(putPolicyEncode) + ":" + putPolicyEncode
    Future.successful(Ok(generateToken(token)))
  }

  private def generateToken(token: String) = "{\"uptoken\": \"" + token + "\"}"

  def deleteFile(fileName: String) = Action.async {
    val path = MANAGE_DELETE_PATH_PREFIX + getEncodeEntryUrl(fileName)
    val auth = MANAGE_DELETE_REQUEST_PREFIX + getAuth(path)
    val ws = getDeleteWs(path, auth)
    ws.post(Results.EmptyContent()) map {
      response =>
        response.status match {
          case 200 =>
            log.info("File: " + fileName + " delete succeed.")
            Application.sendJsonResult(true, "")
          case 400 | 401 | 599 | 612 =>
            val msg = (response.json \ "error").asOpt[String].getOrElse("Unknown error.")
            log.error("File delete failed due to: " + msg +
              ", details: {file: " + fileName + ", path: " + path + ", headers: " + ws.headers.mkString(",") + "}")
            Application.sendJsonResult(false, "File delete failed due to: " + msg)
        }
    }
  }

  private def getDeleteWs(path: String, authToken: String) = ws.url(MANAGE_HOST + path).withHeaders(
    ("Authorization", authToken),
    ("Content-Type", "application/x-www-form-urlencoded")
  )

  private def getEncodeEntryUrl(file: String) = Encryption.urlSafe(Encryption.encodeByBase64(BUCKET_NAME + ":" + file))

  private def getAuth(path: String) = ACCESS_KEY + ":" + Encryption.urlSafe(Encryption.encodeByHmacSha1AndthenBase64(path + "\n", SECRET_KEY))

}

case class PutPolicy(scope: String,
                     deadLine: Long,
                     returnBody: String)