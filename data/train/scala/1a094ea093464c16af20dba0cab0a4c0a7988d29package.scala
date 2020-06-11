import java.io.{File, FileInputStream}
import java.util.zip.GZIPInputStream
import scala.io.{BufferedSource, Source}
import biformat._
/**
  * Provides classes for dealing with bioinfomatics formatted data.
  *
  * ==Overview==
  * The purpose is to make programmers not to concern about VM's heap size.
  * For example, [[WigIterator]] and [[MafIterator]] can manage
  * large data as once-traversable iterator.
  * Also you can use these iterators with functional programing style.
  */
package object biformat {
  def bigSource(f: File): Source = new BufferedSource(
    if (f.getName.endsWith(".gz")) new GZIPInputStream(new FileInputStream(f), 512 * 512)
    else new FileInputStream(f)
    , 512 * 512)

  def bigSource(f: String): Source = bigSource(new File(f))
}
