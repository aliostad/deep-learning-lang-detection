package chap4

object Sect3 extends App {
  
  //関数の引数を固定しない「可変長引数」
  def showMessages(args: String*) = for(arg <- args) println(arg)
  
  showMessages()
  showMessages("a")
  showMessages("A", "B")
  showMessages(Array("c", "d"): _*)//ArrayやListも、「: _*」を付加すれば使用可能
  showMessages(List("E", "F"): _*) //
  
  //デフォルト引数
  def show(msg:String = "hello", count:Int = 1): Unit = {
    var i = 0
    while(i < count) {
      println(msg)
      i += 1
    }
  }
  show()
  show("aiueo")
  show("あいう", 2)
  //show(3)//コンパイルエラー
  show(count = 3)
  show(msg = "えお", count = 4)
  show("かきく", count = 5)
  show(msg = "けこ", 6)
  
  //プレイスホルダ構文
  /*
   * 引数が関数リテラルの中で一度しか使用されない場合、「プレイスホルダ構文」を使用することで、
   * 関数リテラルの記述を、もっと単純にできます。
   */
  //val func: (Int,Int) => Int  = (x:Int, y:Int) => x + y
  val func1: (Int, Int) => Int = _ + _
  val func2 = (_:Int) + (_:Int)
  
  //関数の中で関数を定義する「ローカル関数」
  println("\n★ローカル関数")
  def showLanguages(title:String, langList:List[String]):Unit = {
    def printLang(item:String) = println(title + ":" + item)
    
    langList.foreach(printLang)
  }
  
  showLanguages("Programing Language", List("java", "Scala", "Ruby"))
}