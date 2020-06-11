package com.github.madoc.create_sbt_project.io

import java.io.Writer

import com.github.madoc.create_sbt_project.io.Write.{StringEscapedWrite, WithLineSeparatedByDoubleLineBreaksWrite}

trait Write {
  def apply(str:String):Write
  def apply(ch:Char):Write = apply(ch toString)
  def apply[A](the:A)(implicit output:Output[A]):Write = {output(the)(this); this}
  def line(str:String):Write = apply(str).lineBreak()
  def lineBreak():Write = apply('\n')

  def inQuotes[U](f:Write⇒U):Write = {apply('"'); f(this); apply('"')}
  def stringEscaped:Write = new StringEscapedWrite(this)
  def withLinesSeparatedByDoubleLineBreaks:Write = new WithLineSeparatedByDoubleLineBreaksWrite(this)

  def asJavaIOWriter:Writer = {
    val self = this
    new Writer() {
      def write(cbuf:Array[Char], off:Int, len:Int) {self(new String(cbuf, off, len))}
      def flush() {}
      def close() {}
    }
  }
}
object Write {
  class WriteToAppendable(appendable:Appendable) extends Write {
    def apply(str:String) = {appendable append str; this}
    override def apply(ch:Char) = {appendable append ch; this}
  }

  class StringEscapedWrite(writeUnescaped:Write) extends Write {
    def apply(str:String) = {str foreach apply; this}
    override def apply(ch:Char) = {ch match {
      case '\n' ⇒ writeUnescaped("\\n"); case '\r' ⇒ writeUnescaped("\\r"); case '\t' ⇒ writeUnescaped("\\t")
      case '\\' ⇒ writeUnescaped("\\\\"); case '"' ⇒ writeUnescaped("\\\""); case _ ⇒ writeUnescaped(ch)
    }; this}
  }

  class WithLineSeparatedByDoubleLineBreaksWrite(writeNormal:Write) extends Write {
    private var isRightAfterLineBreak = false
    def apply(str:String) = {str foreach apply; this}
    override def apply(ch:Char) =
      if(ch=='\n') {isRightAfterLineBreak=true; writeNormal(ch); this}
      else {
        if(isRightAfterLineBreak) {writeNormal('\n'); isRightAfterLineBreak=false}
        writeNormal(ch); this
      }
  }
}
