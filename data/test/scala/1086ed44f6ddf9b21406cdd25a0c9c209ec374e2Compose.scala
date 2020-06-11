package svl.learn.scala.functions

object Compose extends App{
    def func1(str:String):String = "func1>>>" + str + "<<<func1"
    def func2(str:String):String = "func2>>>" + str + "<<<func2"
    def func3(str:String):String = "func3>>>" + str + "<<<func3"

    val f = func1 _ compose func2 compose func3
    println(f("*****"))

    def conv(v:String):Int = Integer.parseInt(v)

    def dump(i:Int):Int = {
        println(i)
        i
    }

    def double(i:Int):Int = 2 * i
    def intToString(i:Int):String = "" + i

    val pipeline = intToString _ compose double compose dump compose conv
    println(pipeline("100"))
    println(pipeline("400"))

   val pipeline1 = conv _ andThen dump andThen double andThen intToString
    println(pipeline1("1600"))
    println(pipeline1("6400"))
}
