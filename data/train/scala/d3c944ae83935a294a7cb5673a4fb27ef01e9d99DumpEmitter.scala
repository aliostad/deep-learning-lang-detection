package dbis.piglet.codegen.scala_lang

import dbis.piglet.codegen.{CodeEmitter, CodeGenContext, CodeGenException}
import dbis.piglet.op.Dump

/**
  * Created by kai on 05.12.16.
  */
class DumpEmitter extends CodeEmitter[Dump] {
  override def template: String = """<if(nulling)><in>.foreach{t=>}<else>
    |<in>.collect.foreach(t => println(t.mkString()))<endif>""".stripMargin


  override def code(ctx: CodeGenContext, op: Dump): String = {
    val map = collection.mutable.Map("in" -> op.inPipeName)
    if(op.mute)
      map += ("nulling" -> op.mute.toString()) 
    render(map.toMap)
  }

}

object DumpEmitter {
  lazy val instance = new DumpEmitter 
}
