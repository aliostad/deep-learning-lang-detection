object fibonacci {

  def main(argv:Array[String]) {

    // If there are no arguments: print 20 fibs:
    if (argv.length == 0)
      for (i <- 0 until 10)
        println(fib(i) + "\t" + fib(i+10))

    // Otherwise, fib the argument:
    else
      println(fib(argv(0).toInt))

  }

  def fib (rot:Int) : Int = {

    var tmp = 0
    var old_value = 1
    var new_value = 0
    
    for (i <- 0 until rot) {
      tmp = old_value
      old_value = new_value
      new_value = tmp + old_value
    }

    return new_value
  }

}

/* TAIL INFO
 * Name: Fibonacci Sequence
 * Language: Scala
 * Compile: scalac fibonacci.scala
 * State: Done
 *
 * Prints out numbers from the fibonacci sequence
 *
 * Example: scala fibonacci
 * Example2: scala fibonacci 42
*/
