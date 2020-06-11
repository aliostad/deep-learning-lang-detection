package src.dp.Z25.srp

import src.dp.Z25.srp.userState.{CommonUserState, NormalUserState, TUserState, VipUserState}

/**
  * Created by gary on 5/22/16.
  */
class UserManager(private val auth: Int) extends TUserManage{
  private var state: TUserState=_

  private def changeState(state: TUserState): Unit = {
    this.state = state
  }

  override def process(): Unit = {
    this.auth match {
      case 1 => this.changeState(new NormalUserState)
      case 2 => this.changeState(new CommonUserState)
      case 3 => this.changeState(new VipUserState)
      case _ => throw new Exception("权限输入错误")
    }
    if (this.state != null)
      this.state.exec()
  }
}
