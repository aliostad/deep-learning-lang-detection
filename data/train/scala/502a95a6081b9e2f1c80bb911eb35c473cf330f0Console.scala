package System

object Console {
  def WriteLine(s:String)
  {
    if (s != null)
      java.lang.System.out.println(s);
  }
  
  def WriteLine(i:Int)
  {
    java.lang.System.out.println(i.toString());
  }
  def WriteLine(i:Double)
  {
    java.lang.System.out.println(i.toString());
  }
  def WriteLine(i:Boolean)
  {
    java.lang.System.out.println(i.toString());
  }
  def WriteLine(o:Any)
  {
    if (o != null)
      java.lang.System.out.println(o.toString());
  }
  
  def Write(s:String)
  {
    java.lang.System.out.print(s);
  }
  
  def ReadLine():String =
  {
    throw new NotImplementedException("stub");
  }

}