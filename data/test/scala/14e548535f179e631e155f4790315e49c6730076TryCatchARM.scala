//: TryCatchARM.scala
package practice

import scala.util.control.NonFatal


object Manage {

  def apply[R <: { def close(): Unit }, T]( resource: => R )( f: R => T ) = {

    var res: Option[R] = None

    try {
      res = Some( resource )
      f( res.get )
    } catch {
      case NonFatal(ex) => println( s"Non fatal exception! $ex" )
    } finally {
      if ( res.isDefined ) {
        println( s"Closing resource..." )
        res.get.close()
      }
    }

  }

} //:~

object TryCatchARM {

  def main( args: Array[String] ) = {
    args foreach ( arg => countLines( arg ) )
  }

  import scala.io.Source

  def countLines( fileName: String ) = {

    println()
    Manage( Source.fromFile(fileName) ) { source =>
      val size = source.getLines().size
      println( s"file $fileName has $size lines" )

      if ( size > 20 ) {
        throw new RuntimeException( s" $fileName is a big file!" )
      }
    }

  }

  @annotation.tailrec
  def continue( condition: => Boolean )( body: => Unit ) {
    if ( condition ) {
      body
      continue( condition )( body )
    }
  }

} //:~
