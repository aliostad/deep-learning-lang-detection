import scala.util.Random

/**
Lotto: Draw N different random numbers from the set 1..M.
Example:
scala> lotto(6, 49)
res0: List[Int] = List(23, 1, 17, 33, 21, 37)
  */

// 1- My Solution
def removeAt[A](n: Int, input: List[A]): (List[A], A) = {
  val (a, b) = input.splitAt(n)
  (a ::: b.tail, b.head)
}

def randomSelect[A](n: Int, input: List[A]): List[A] = {
  var (oldList, newList) = (input, List[A]())

  for (i <- 0 until n) {
    val randomIndex = Random.nextInt(oldList.length)
    val ret = removeAt(randomIndex, oldList)
    oldList = ret._1
    newList = ret._2 :: newList
  }
  newList
}

// A bit too simple if you're re-using the ramdomSelect solution
def lotto(num: Int, len: Int): List[Int] = {
  randomSelect(num, List.range(1, len + 1))
}

//3- Tests
println("Starting tests...")

// Basic 6/49 test
val num = 6
val len = 49
val result1 = lotto(num, len)
assert(result1.length == 6)
for (i <- result1) assert(i <= 49)

// Ensure all elements get selected
val max = 100
val result2 = lotto(max, max)
for (i <- result2) assert(i <= max)
println("All tests passed!")
