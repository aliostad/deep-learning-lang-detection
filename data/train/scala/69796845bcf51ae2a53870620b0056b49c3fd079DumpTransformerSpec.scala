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
package test

import dump.DumpTransformer
import java.io.File
import Zip.extract
import scala.xml.XML

/**
 * @author Philip Cali
 **/
class DumpTransformerSpec extends TransformerSpec {
  val transformer = DumpTransformer(working, "temp")

  def file = XML.load(working + "_dump/dump.xml")

  "Dump Transformer" should "produce a dump archive" in {
    new File(working + "_dump.zip") should be ('exists)
  }

  it should "produce a replicate directory structure" in {
    extract(working + "_dump.zip", "temp")

    new File(working + "_dump/syllabus_dir") should be ('exists)
    new File(working + "_dump/important_dir") should be ('exists)
  }

  it should "produce a valid xml" in {
    (file \\ "COURSE").size should be === 1
  }
  
  it should "produce the right number of sections" in {
    (file \\ "ORGANIZATION" \ "MODULES" \ "MODULE").size should be === 3
  }

  "The first section" should "produce the correct number of modules" in {
    ((file \\ "ORGANIZATION" \ "MODULES" \ "MODULE")(0) \\ "MODULE") .size should be === 6
  }

  it should "produce the correct module types" in {
    val types = for(module <- (file \\ "ORGANIZATION" \ "MODULES" \ "MODULE")(0) \ "MODULES" \\ "MODULE") 
      yield {
        module \ "TYPE" text
      }
    
    val expected = List("Label", "SingleFile", "OnlineDocument", "Directory", "ExternalLink")

    types.mkString(" ") should be === expected.mkString(" ")
  }

  "Non display content" should "render just the same" in {
    (file \\ "NONDISPLAY" \ "MODULE").size should be === 1
  }

  it should "contain a question category" in {
    (file \\ "NONDISPLAY" \ "MODULE" \ "TYPE").text should be === "QuestionCategory"
  }

  "Question Category" should "contain the right questions" in {
    val types = for(question <- file \\ "NONDISPLAY" \\ "QUESTION") yield (question \ "TYPE" text)

    val expected = List("MultipleChoice", "Essay", "BooleanQuestion", "Matching")

    types.mkString(" ") should be === expected.mkString(" ")
  }
}
