package org.openurp.edu.eams.teach.web.action.code

import org.openurp.edu.eams.base.web.action.code.AbstractManageAction
import org.openurp.edu.eams.teach.code.industry.ExamType
import org.openurp.edu.eams.teach.code.industry.OtherExamCategory
import org.openurp.edu.eams.teach.code.industry.PressLevel



class ManageAction extends AbstractManageAction {

  def editGradeType(): String = {
    put("examTypes", baseCodeService.getCodes(classOf[ExamType]))
    getExtEditForward
  }

  def editPress(): String = {
    put("pressLevels", baseCodeService.getCodes(classOf[PressLevel]))
    getExtEditForward
  }

  def editOtherExamSubject(): String = {
    put("otherExamCategoryList", baseCodeService.getCodes(classOf[OtherExamCategory]))
    getExtEditForward
  }

  def editCourseType(): String = getExtEditForward

  def editCourseTakeType(): String = getExtEditForward

  def editExamStatus(): String = getExtEditForward

  def editScoreMarkStyle(): String = getExtEditForward
}
