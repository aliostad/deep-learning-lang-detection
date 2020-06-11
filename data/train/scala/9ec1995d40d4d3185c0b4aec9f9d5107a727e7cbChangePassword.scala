package code.snippet

import code.model._
import net.liftweb.common.{Failure, Full}
import net.liftweb.http.{S, SHtml, StatefulSnippet}
import net.liftweb.util.Helpers._

/**
 *  處理「更改密碼」頁面的表單
 *
 */
class ChangePassword extends StatefulSnippet {
  
  private var oldPassword: String = ""        // 用來儲存使用者輸入的「原來的密碼」欄位
  private var password: String = ""           // 用來儲存使用者輸入的「新的密碼」欄位
  private var confirmPassword: String = ""    // 用來儲存使用者輸入的「確認密碼」欄位

  /**
   *  當使用者送出表單後執行的函式
   *
   *  @param    value     HTML 上送出按鈕的 value 屬性
   */
  def process(value: String): Unit = {
    val result = for {
      oldPassword          <- Full(oldPassword).filterNot(_.trim.isEmpty) ?~ "請輸入舊的密碼"
      currentUser          <- User.CurrentUser.get ?~ "查無此使用者"
      _                    <- Full(oldPassword).filter(x => currentUser.password.match_?(x)) ?~ "舊密碼錯誤"
      passwordValue        <- Full(password).filterNot(_.trim.isEmpty) ?~ "請輸入密碼"
      confirmPasswordValue <- Full(confirmPassword).filter(_ == passwordValue) ?~ "兩個密碼不符，請重新檢查"
      updatedUser          <- currentUser.password(confirmPasswordValue).saveTheRecord()
    } yield {
      updatedUser
    }

    result match {
      case Full(worker)     => S.redirectTo("/", () => S.notice("成功變更密碼"))
      case Failure(x, _, _) => S.error(x)
      case _ =>
    }

  }

  /**
   *  用來顯示及綁定 HTML 模板上的表單
   */
  def render = {
    "#oldPassword"     #> SHtml.password(oldPassword, oldPassword = _) &
    "#password"        #> SHtml.password(password, password = _) &
    "#confirmPassword" #> SHtml.password(confirmPassword, confirmPassword = _) &
    "type=submit"      #> SHtml.onSubmit(process _)
  }

  /**
   *  指定 HTML 中呼叫的 Snippet 名稱要對應到哪些函式
   *
   *  為了讓使用者在輸入表單後，若有錯誤而無法進行時，原先輸入的值還會留在表單上，需
   *  要使用 StatefulSnippet 的機制，也就是讓此類別繼承自 StatefulSnippet 這個 trait。
   *
   *  但如果是 StatefulSnippet，會需要自行指定 HTML 模板中， data-lift="ChangePassword.render" 裡
   *  面的 "render" 對應到哪個函式。
   */
  def dispatch = {
    case "render" => render
  }

}
