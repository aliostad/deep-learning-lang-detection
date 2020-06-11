package controllers

import controllers.Application._
import models.Staff._
import play.api.mvc.Controller
import models.Staff
import models.User
import models.User._
import play.api.mvc._
import views._
/**
 * Created by lustre on 2015/7/21.
 */
object Staffs extends Controller with Secured{

  /**
   * Display the dashboard.
   */
  def index = IsAuthenticated { username => _ =>
    User.findByuser_id(username).map { user =>
      if(Staff.getIdentify(username).equals("3")) {
        Ok(views.html.userManage(Staff.all(), Staff.staffForm, username, User.identify(username)))
      }
      else{
        Redirect(routes.Application.viewAttendOfOne(username,"","")) //这里的username即user_id
      }
    }.getOrElse(Forbidden)
  }

}
