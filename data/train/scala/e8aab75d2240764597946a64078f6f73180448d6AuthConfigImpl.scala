package controllers

import jp.t2v.lab.play2.auth.{CookieTokenAccessor, AuthConfig}
import models.Role
import play.api.mvc.{Result, RequestHeader}
import play.api.mvc.Results._
import services.ManageUserWithElasticsearchService

import scala.concurrent.{Future, ExecutionContext}
import scala.reflect._

trait AuthConfigImpl extends AuthConfig {

  // 依存解決を諦めた図
  val _manageUserService = new ManageUserWithElasticsearchService

  /**
   * ユーザを識別するIDの型です。String や Int や Long などが使われるでしょう。
   */
  type Id = Long

  /**
   * あなたのアプリケーションで認証するユーザを表す型です。
   * User型やAccount型など、アプリケーションに応じて設定してください。
   */
  type User = models.User

  /**
   * 認可(権限チェック)を行う際に、アクション毎に設定するオブジェクトの型です。
   * このサンプルでは例として以下のような trait を使用しています。
   *
   * sealed trait Role
   * case object Administrator extends Role
   * case object NormalUser extends Role
   */
  type Authority = Role

  /**
   * CacheからユーザIDを取り出すための ClassTag です。
   * 基本的にはこの例と同じ記述をして下さい。
   */
  val idTag: ClassTag[Id] = classTag[Id]

  /**
   * セッションタイムアウトの時間(秒)です。
   */
  val sessionTimeoutInSeconds: Int = 3600

  /**
   * ユーザIDからUserブジェクトを取得するアルゴリズムを指定します。
   * 任意の処理を記述してください。
   */
  def resolveUser(id: Id)(implicit ctx: ExecutionContext) = _manageUserService.getUserById(id)

  /**
   * ログインが成功した際に遷移する先を指定します。
   */
  def loginSucceeded(request: RequestHeader)(implicit ctx: ExecutionContext): Future[Result] =
    Future.successful(Redirect(routes.RootController.index))

  /**
   * ログアウトが成功した際に遷移する先を指定します。
   */
  def logoutSucceeded(request: RequestHeader)(implicit ctx: ExecutionContext): Future[Result] =
    Future.successful(Redirect(routes.RootController.index))

  /**
   * 認証が失敗した場合に遷移する先を指定します。
   */
  def authenticationFailed(request: RequestHeader)(implicit ctx: ExecutionContext): Future[Result] =
    Future.successful(Redirect(routes.RootController.welcome))

  /**
   * 認可(権限チェック)が失敗した場合に遷移する先を指定します。
   */
  override def authorizationFailed(request: RequestHeader, user: User, authority: Option[Authority])(implicit context: ExecutionContext): Future[Result] = {
    Future.successful(Forbidden("no permission"))
  }

  /**
   * 権限チェックのアルゴリズムを指定します。
   * 任意の処理を記述してください。
   */
  def authorize(user: User, authority: Authority)(implicit ctx: ExecutionContext): Future[Boolean] = Future.successful {
//    (user.role, authority) match {
//      case (Administrator, _) => true
//      case (NormalUser, NormalUser) => true
//      case _ => false
//    }
    true
  }

  /**
   * (Optional)
   * SessionID Tokenの保存場所の設定です。
   * デフォルトでは Cookie を使用します。
   */
  override lazy val tokenAccessor = new CookieTokenAccessor(
    /*
     * cookie の secureオプションを使うかどうかの設定です。
     * デフォルトでは利便性のために false になっていますが、
     * 実際のアプリケーションでは true にすることを強く推奨します。
     */
    cookieSecureOption = false,
    cookieMaxAge       = Some(sessionTimeoutInSeconds)
  )

}