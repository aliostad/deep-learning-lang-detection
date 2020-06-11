package ops.android.app

import android.app.{Fragment, FragmentManager, FragmentTransaction}

import scala.language.reflectiveCalls
import scala.reflect.ClassTag

trait FragmentManageable {

  self: { def getFragmentManager(): FragmentManager } =>

  def fragmentManage(ft: FragmentTransaction => Unit): Unit = {
    val t = getFragmentManager().beginTransaction()
    ft(t)
    t.commit()
  }

  implicit class FragmentTransactionOps(self: FragmentTransaction) {

    def replaceOrElse[T <: Fragment](fm: FragmentManager, containerViewId: Int, f: => T)(implicit classTag: ClassTag[T]) = {
      val tag = classTag.runtimeClass.getName
      val fragment = Option(fm.findFragmentByTag(tag)) getOrElse f
      self.replace(containerViewId, fragment, tag)
    }
  }

}
