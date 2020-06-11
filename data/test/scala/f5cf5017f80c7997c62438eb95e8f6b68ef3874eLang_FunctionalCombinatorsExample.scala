/**
* Examples based on: https://twitter.github.io/scala_school/collections.html
**/

object Lang_FunctionalCombinatorsExample {
  def main(args: Array[String]) {

    //List Collection Manage Examples Function
    listExamplesFunction

    //set Collection Manage Examples Function
    setExamplesFunction

    //Tuple Collection Manage Examples Function
    //tupleExamplesFunction

    //Map Collection Manage Examples Function
    mapExamplesFunction

  }

  def listExamplesFunction:Unit = {
    val numberList = List(1, 2, 3, 4)
    println("numberList._1: " + numberList.lift(1))
    println("numbers.map((i: Int) => i * 2): " +numberList.map((i: Int) => i * 2)) //example of map Combinators
    def timesTwo(i: Int): Int = i * 2
    println("numberList.map(timesTwo): " + numberList.map(timesTwo)) //example of map combinator using a function
    println("numberList.foreach((i: Int) => i * 2): " + numberList.foreach((i: Int) => i * 2)) //example of foreach combinator
    println("numberList.filter((i: Int) => i % 2 == 0): " + numberList.filter((i: Int) => i % 2 == 0)) //example of fliter combinator

  }

  def setExamplesFunction:Unit = {
    val numberSet = Set(3, 9, 5, 4, 4, 2, 4, 3)
    println("numberSet._1: " + numberSet)  // get elements of set
    println("numberSet._1: " + numberSet(2))  //check if 2 is in set: true
    println("numberSet._1: " + numberSet(10)) //check if 10 is in set: false

  }

  def tupleExamplesFunction:Unit = {
    val hostPortTuple = ("localhost", 80)
    println("hostPortTuple._1: " + hostPortTuple._1)
  }

  def mapExamplesFunction:Unit = {
    val map = Map(1 -> 2, "a" -> "b")
    println("map.get(1): " + map.get(1))
    println("map.get('a'): " + map.get("a"))
  }

}

//FunctionlCombinatorsExample.main(args)
