package org.openurp.edu.eams

import org.beangle.commons.inject.bind.AbstractBindModule
import org.openurp.edu.base.Course.web.action.CourseAction
import org.openurp.edu.base.Course.web.action.CourseSearchAction
import org.openurp.edu.eams.teach.lesson.helper.LessonSearchHelper
import org.openurp.edu.eams.teach.web.action.code.ManageAction



class TeachWebModule extends AbstractBindModule {

  protected override def doBinding() {
    bind(classOf[org.openurp.edu.eams.web.action.api.CourseAction])
    bind(classOf[org.openurp.edu.eams.web.action.api.AdminclassAction])
    bind(classOf[org.openurp.edu.eams.web.action.api.NormalclassAction])
    bind(classOf[org.openurp.edu.eams.web.action.api.ProgramAction])
    bind(classOf[CourseAction])
    bind(classOf[CourseSearchAction])
    bind("lessonSearchHelper", classOf[LessonSearchHelper])
    bind(classOf[ManageAction])
  }
}
