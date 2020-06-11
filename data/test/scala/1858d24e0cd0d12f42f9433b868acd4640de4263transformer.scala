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

import Zip.archive
import system.{Tagger, TransformerTag}
import transformer.Transformer
import Utils.{remove, copy}
import course._
import java.io.{File => JFile}
import DumpConversions._

/**
 * @author Philip Cali
 **/
class DumpTransformerTag extends TransformerTag {
  def name = "dump"
  def version = "1.0"
  def suffix = "_dump"
}

/**
 * @author Philip Cali
 **/
object DumpTransformer extends Tagger[DumpTransformerTag] {
  def tag = new DumpTransformerTag
  def apply(working: String, output: String = "./") = new DumpTransformer(working, output)
}

/**
 * @author Philip Cali
 **/
class DumpTransformer(val working: String, val output: String) extends Transformer {
  def staging = {
    val oldDir = new JFile(working)
    val newDir = new JFile(oldDir.getName + "_dump")
    
    if(!newDir.exists) {
      newDir.mkdir
    }

    newDir.getName
  }

  def transform(course: Course) {
    course.sections.foreach { section => 
      course.mods(section).foreach(_.transform(working, staging))
    }

    def courseXML = {
      <COURSE>
        <INFO>
          <TITLE>{ course.info.title }</TITLE>
          <DESCRIPTION>{ course.info.description }</DESCRIPTION>
        </INFO>
        <ORGANIZATION>
          <MODULES>{ course.sections.map(_.toXML) }
          </MODULES>
        </ORGANIZATION>
        <NONDISPLAY>{ course.nondisplay.map(_.toXML) }
        </NONDISPLAY>
      </COURSE>
    }

    scala.xml.XML.save(staging + "/dump.xml", courseXML, "UTF-8", true)
    
    archive(staging, output) 

    cleanup()
  }

  def cleanup() = { 
    remove(staging)
    remove(working)
  }
}
