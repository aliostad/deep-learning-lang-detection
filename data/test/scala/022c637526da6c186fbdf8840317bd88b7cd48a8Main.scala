package learn.fpscala.exercise.chapter15


object Main extends App {

  val liftOne = Process.liftOne((x: Int) => x * 2)
  val lift = Process.lift((x: Int) => x * 2)

  println(
    liftOne(Stream(1, 2, 3)).toList
  )

  println(
    lift(Stream(1, 2, 3)).toList
  )

  println(
    Process.sum(Stream(1, 2, 3)).toList
  )

  println(
    "3 elements - take 4: " + Process.take(4)(Stream(1, 2, 3)).toList +
      "         7 elements - take 4: " + Process.take(4)(Stream(1, 2, 3, 4, 5, 6, 7)).toList
  )

  println(
    "3 elements - drop 4: " + Process.drop(4)(Stream(1, 2, 3)).toList +
      "         7 elements - drop 4: " + Process.drop(4)(Stream(1, 2, 3, 4, 5, 6, 7)).toList
  )


  println(
    "3 elements - takie while 4: " + Process.takeWhile((x: Int) => x < 3)(Stream(1, 2, 3)).toList
  )
  println(
    "Process.count(Stream(1, 2, 3, 4, 5)).toList: " + Process.count(Stream(1, 2, 3, 4, 5)).toList +
      "\nProcess.count(Stream(1)).toList: " + Process.count(Stream(1)).toList
  )


}
