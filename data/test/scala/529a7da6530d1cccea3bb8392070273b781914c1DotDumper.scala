// timber -- Copyright 2012-2015 -- Justin Patterson
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package org.scalawag.timber.backend.dispatcher.configuration.debug

import java.io.{FileWriter, File, PrintWriter}
import org.scalawag.timber.backend.dispatcher.configuration._

private class DotDumper(out:IndentingPrintWriter) {
  private var dumped = Set[String]()

  private def getId(vertex:ImmutableVertex) = System.identityHashCode(vertex).toString

  private def dump(configuration:Configuration) {
    out.println("digraph Configuration {")
    out.indent {
      out.println("""ranksep="1in";""")
      out.println("{")
      out.indent {
        out.println("""rank="source";""")
        out.println(""""root" [label="root",shape="invhouse"];""")
      }
      out.println("}")

      configuration.roots.foreach(dumpElement(_,Some("root")))
    }
    out.println("}")
  }

  private def dumpEdge(fromId:String,to:ImmutableVertex) {
    val toId = getId(to)
    out.println(""""%s":s -> "%s":n""".format(fromId,toId))
  }

  private def escape(s:String) = s.replaceAllLiterally("\"","\\\"").replaceAll("\n","\\\\n")

  private def dumpVertex(vertex:ImmutableVertex,props:Map[String,String],rank:Option[String] = None) {
    val id = getId(vertex)

    def format(props:Map[String,String]):String = props map { case (k,v) =>
      """%s="%s"""".format(k,escape(v))
    } mkString(",")

    if ( rank.isDefined ) {
      out.println("{")
      out.changeIndent(1)
      out.println("""rank="%s";""".format(rank.get))
    }

    out.println(""""%s" [%s];""".format(id,format(props)))

    if ( rank.isDefined ) {
      out.changeIndent(-1)
      out.println("}")
    }
  }

  private def dumpElement(vertex:ImmutableVertex,parent:Option[String] = None) {
    val id = getId(vertex)
    if ( ! dumped.contains(id) ) {

      val (rank,props) = vertex match {
        case f:ImmutableConditionVertex =>
          val label = f.condition.toString
          (None,Map("shape" -> "rect","label" -> label))
        case r:ImmutableReceiverVertex =>
          (Some("sink"),Map("shape" -> "house","label" -> r.receiver.toString))
      }

      dumpVertex(vertex,props,rank)

      vertex match {
        case o:ImmutableConditionVertex => o.nexts.foreach(dumpElement(_,Some(id)))
        case o:ImmutableReceiverVertex => // noop
      }

      dumped += id
    }
    parent.foreach(dumpEdge(_,vertex))
  }
}

object DotDumper {

  def dump(configuration:Configuration,out:PrintWriter):Unit = (new DotDumper(new IndentingPrintWriter(out))).dump(configuration)

  def dump(configuration:Configuration,file:File):Unit = {
    val out = new PrintWriter(new FileWriter(file))
    try {
      DotDumper.dump(configuration,out)
    } finally {
      out.close()
    }
  }

}

