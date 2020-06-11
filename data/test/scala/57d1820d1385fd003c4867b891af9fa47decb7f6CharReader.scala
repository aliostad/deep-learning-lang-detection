package utils

import java.nio.charset.Charset

/** The EOD (End Of Data) exception is thrown when there is no more data to read.
 *  this is way more effective on most data flows than checking if the end has
 *  been reached before reading a new character.
 */
final class EOD extends Exception {
  override def fillInStackTrace = this
}

/** A char reader with a buffer of one */
trait CharReader {
  /** puts one character back into the stream */
  def reject():Unit
  /** takes the next character */
  @throws(classOf[EOD])
  def nextChar:Char
}

/** Important note: these CharReader don't care for charset. This means that if you use
 *  apply(s:Array[Byte]), then Byte are cast as Char on binary terms, not using any conversion.
 *  This may be of use in some cases. If you need charset, you can always wrap the appropriate
 *  Stream or Reader for the task.
 */
object CharReader {
  val eod = new EOD
  
  implicit def apply(s:Array[Char]):CharReader = new CharReader {
    private[this] var i= -1
    def nextChar = try { i+=1; s(i).asInstanceOf[Char] } catch { case _:Exception=> throw eod }
    def reject() = i-=1
  }
  implicit def apply(s:Array[Byte]):CharReader = new CharReader {
    private[this] var i= -1
    final def nextChar = try { i+=1; (s(i) & 0xFF).asInstanceOf[Char] } catch { case _:Exception=>throw eod }
    final def reject() = i-=1
  }
  implicit def apply(in:java.io.Reader):CharReader = new CharReader {
    private[this] var c:Int=_
    def nextChar = (if (c<0) { c= -c; c } else { c=in.read; if (c<0) throw eod else c }).asInstanceOf[Char]
    def reject() = c = -c
  }
  implicit def apply(in:java.io.InputStream):CharReader = new CharReader {
    private[this] var c:Int=_
    def nextChar = (if (c<0) { c= -c; c } else { c=in.read; if (c<0) throw eod else c }).asInstanceOf[Char]
    def reject() = c = -c
  }
  implicit def apply(s:java.nio.CharBuffer):CharReader = new CharReader {
    private[this] var hasOld=false
    private[this] var old:Char=0
    final def nextChar = if (hasOld) { hasOld=false; old } else try { old=s.get; old } catch { case _:Exception=>throw eod }
    final def reject() = hasOld=true
  }
  def apply(s:java.nio.ByteBuffer,charset:String):CharReader = new CharReader {
    private[this] var hasOld=false
    private[this] var old:Char=0
    private[this] val buf = Charset.forName(charset).decode(s)
    final def nextChar = if (hasOld) { hasOld=false; old } else try { old=buf.get; old } catch { case _:Exception=>throw eod }
    final def reject() = hasOld=true
  }
  def apply(s:Array[Byte],charset:String):CharReader = apply(java.nio.ByteBuffer.wrap(s),charset)
}
