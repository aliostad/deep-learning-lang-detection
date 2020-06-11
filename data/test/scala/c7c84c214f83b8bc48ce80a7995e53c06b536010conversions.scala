// Scala Course Converter is a command-line utility that gives the end user
// the ability to convert one e-learning management system course archive
// to another e-learning management system course archive.
// 
// 
// Copyright (C) 2010 Philip Cali 
// 
// 
// Scala Course Converter is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
package com.github.philcali.cct

package dump

import course._
import java.io.{File => JFile}
import Utils.copy

/**
 * @author Philip Cali
 **/
object DumpConversions {
  implicit def module2DumpModule(m: CourseModule): DumpModule = m.wrapped match {
    case l: Label => new DumpLabel(m, l)
    case s: SingleFile => new DumpSingleFile(m, s)
    case d: Directory => new DumpDirectory(m, d)
    case o: OnlineDocument => new DumpOnline(m, o)
    case e: ExternalLink => new DumpExternalLink(m, e)
    case staff: StaffInformation => new DumpStaffInformation(m, staff)
    case quiz: Quiz => new DumpQuiz(m, quiz)
    case section: Section => new DumpSection(m, section)
    case _ => new DumpUnknown(m, m.wrapped)
  }

  implicit def nondisplay2DumpModule(m: Module) = m match {
    case category: QuestionCategory => new DumpCategory(category)
    case _ => new DumpUnknown(CourseModule(m, 0, Nil), m)
  }
}

/**
 * @author Philip Cali
 **/
trait XMLOuput {
  def toXML: scala.xml.Node
  def extraXML = <EXTRA/>
}

/**
 * @author Philip Cali
 **/
trait DumpModule extends XMLOuput {
  import DumpConversions._

  val under: CourseModule
  val module: Module

  def tpe = module.getClass.getSimpleName

  def transform(working: String, staging: String) = {
    val oldDir = new JFile(working + "/" + module.from)
    if(oldDir.exists) {
      val newDir = new JFile(staging + "/" + module.from)

      copy(oldDir, newDir)
    }
  }

  def toXML = {
    <MODULE>
      <ID>{ module.id }</ID>
      <LEVEL>{ under.level }</LEVEL>
      <TYPE>{ tpe }</TYPE>
      <NAME>{ module.name }</NAME>
      <REFERENCE>{ module.from }</REFERENCE>
      { extraXML }
      <MODULES>{ under.children.map(_.toXML) }</MODULES>
    </MODULE>
  }
}

/**
 * @author Philip Cali
 **/
trait FileHandler {
  def fileXML(file: File) = {
    <FILE>
      <NAME>{ file.name }</NAME>
      <LINKNAME>{ file.linkname }</LINKNAME>
      <SIZE>{ file.size }</SIZE>
    </FILE>
  }  
}

/**
 * @author Philip Cali
 **/
class DumpUnknown(val under: CourseModule, val module: Module) extends DumpModule {
  override def tpe = "unsupported"
}

/**
 * @author Philip Cali
 **/
class DumpSection(val under: CourseModule, val module: Section) extends DumpModule 

/**
 * @author Philip Cali
 **/
class DumpLabel(val under: CourseModule,val module: Label) extends DumpModule

/**
 * @author Philip Cali
 **/
class DumpSingleFile(val under: CourseModule,val module: SingleFile) extends DumpModule with FileHandler{
  override def extraXML = fileXML(module.file)
}

/**
 * @author Philip Cali
 **/
class DumpDirectory(val under: CourseModule,val module: Directory) extends DumpModule with FileHandler {
  override def extraXML = {
    <FILES>{ module.directory.map(fileXML) }</FILES>
  }
}

/**
 * @author Philip Cali
 **/
class DumpOnline(val under: CourseModule, val module: OnlineDocument) extends DumpModule {
  override def extraXML = {
    <TEXT>{ module.text }</TEXT>
  }
}

/**
 * @author Philip Cali
 **/
class DumpExternalLink(val under: CourseModule, val module: ExternalLink) extends DumpModule {
  override def extraXML = {
    <LINK>{ module.url }</LINK>
  }
}

/**
 * @author Philip Cali
 **/
class DumpStaffInformation(val under: CourseModule, val module: StaffInformation) extends DumpModule{
  override def extraXML = {
    <CONTACT>
      <TITLE>{ module.contact.title }</TITLE>
      <GIVEN>{ module.contact.given }</GIVEN>
      <FAMILY>{ module.contact.family }</FAMILY>
      <EMAIL>{ module.contact.email }</EMAIL>
      <PHONE>{ module.contact.phone }</PHONE>
      <OFFICE>{ module.contact.office }</OFFICE>
      <IMAGE>{ module.contact.image }</IMAGE>
    </CONTACT>
  }
}

/**
 * @author Philip Cali
 **/
class DumpQuiz(val under: CourseModule, val module: Quiz) extends DumpModule {
  import DumpConversions.nondisplay2DumpModule  

  override def extraXML = {
    <EXTRA>
      <INFO>{ module.description }</INFO>
      { module.category.toXML } 
    </EXTRA>
  }
}

/**
 * @author Philip Cali
 **/
trait DumpQuestion extends XMLOuput {
  val question: Question

  implicit def answer2DumpAnswer(answer: Answer) = new DumpAnswer(answer)

  // Look at a better way to get the actual question type
  def toXML = {
    <QUESTION>
      <ID>{ question.id }</ID>
      <TYPE>{ question.getClass.getInterfaces.head.getSimpleName }</TYPE>
      <NAME>{ question.name }</NAME>
      <TEXT>{ question.text }</TEXT>
      <GRADE>{ question.grade }</GRADE>
      <ANSWERS>{ question.answers.map(_.toXML) }
      </ANSWERS>
    </QUESTION>
  }
}

/**
 * @author Philip Cali
 **/
class DumpAnswer(val answer: Answer) extends XMLOuput {
  def toXML = {
    <ANSWER>
      <ID>{answer.id}</ID>
      <NAME>{answer.text}</NAME>
      <WEIGHT>{answer.weight}</WEIGHT>
      <FEEDBACK>{answer.feedback}</FEEDBACK>
    </ANSWER>
  }
}

/**
 * @author Philip Cali
 **/
class DumpCategory(val module: QuestionCategory) extends DumpModule {
  val under = CourseModule(module, 0, Nil)

  implicit def question2DumpQuestion(q: Question) = q match {
    case multi: MultipleChoice => new DumpMultipleChoice(multi)
    case essay: Essay => new DumpEssay(essay)
    case tf: BooleanQuestion => new DumpBooleanQuestion(tf)
    case matc: Matching => new DumpMatching(matc)
    case order: Ordering => new DumpOrdering(order)
    case fillb: FillInBlank => new DumpFillInBlank(fillb)
    case num: Numeric => new DumpNumeric(num)
  }

  override def extraXML = {
    <CATEGORY>
      <INFO>{ module.info }</INFO>
      <QUESTIONS>{ module.questions.map(_.toXML) }
      </QUESTIONS>
    </CATEGORY>
  }
}

/**
 * @author Philip Cali
 **/
class DumpMultipleChoice(val question: MultipleChoice) extends DumpQuestion {
  override def extraXML = {
    <EXTRA>
      <INCORRECTFEEDBACK>{ question.incorrectFeedback }</INCORRECTFEEDBACK>
      <CORRECTFEEDBACK>{ question.correctFeedback}</CORRECTFEEDBACK>
    </EXTRA>
  }
}

/**
 * @author Philip Cali
 **/
class DumpMatching(val question: Matching) extends DumpQuestion
/**
 * @author Philip Cali
 **/
class DumpBooleanQuestion(val question: BooleanQuestion) extends DumpQuestion {
  override def extraXML = {
    <EXTRA>
      <TRUE>{ question.trueAnswer }</TRUE>
      <FALSE>{ question.falseAnswer }</FALSE>
    </EXTRA>
  }
}
/**
 * @author Philip Cali
 **/
class DumpEssay(val question: Essay) extends DumpQuestion
/**
 * @author Philip Cali
 **/
class DumpOrdering(val question: Ordering) extends DumpQuestion
/**
 * @author Philip Cali
 **/
class DumpFillInBlank(val question: FillInBlank) extends DumpQuestion
/**
 * @author Philip Cali
 **/
class DumpNumeric(val question: Numeric) extends DumpQuestion {
  override def extraXML = {
    <EXTRA>
      <TOLERANCE>{ question.tolerance }</TOLERANCE>
    </EXTRA>
  }
}
