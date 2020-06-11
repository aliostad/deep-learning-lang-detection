import scala.io.StdIn.readLine

object Solution {

    def miss_nums(arr1: Array[String], arr2: Array[String]): Array[String] = {
        val counts1 = arr1.groupBy(identity).mapValues(_.size)
        val counts2 = arr2.groupBy(identity).mapValues(_.size)

            return arr2.distinct.filter{n =>
                counts1(n) < counts2(n)
                }
                .sortWith(_ < _)
    }

    def main(args: Array[String]) {
        var dump = readLine()
        val arr1 = readLine().split(" ")
        dump = readLine()
        val arr2 = readLine().split(" ")
        val res = miss_nums(arr1, arr2)
        println(res.mkString(" "))
    }
}
