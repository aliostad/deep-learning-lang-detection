package mock_exam

/**
 * Created by liliya on 16/04/2015.
 * Example of decorator pattern in scala* 
 */
object Decorate extends App {
  
  new FOS("foo.txt") with Buffered  //mixin with Buffered

}

trait OutputStream {
  def write(b:Byte)
  def write(b:Array[Byte])  
}

trait Buffered extends OutputStream{
  abstract override def write(b:Byte):Unit = {
    //some buffer used in some way
    super.write(b)
    
  }
  
}

class FOS(path:String) extends OutputStream{
  override def write(b: Byte): Unit = ???

  override def write(b: Array[Byte]): Unit = ???
}