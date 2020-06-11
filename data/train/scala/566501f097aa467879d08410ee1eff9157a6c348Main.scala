import java.io.{File, PrintWriter}

import algorithms.{SCH, SHE, SH}
import data.Problem
import data.Types.Solution

import scala.language.postfixOps
import scala.util.Random
import scala.concurrent.duration._

/**
  * Created by alejandro on 29/05/16.
  */
object Main {

  def main(args: Array[String]) {
//    val Problem(size, costes, cities, greedy) = Problem.a280
//
////    println("greedy: " + greedy(0))
////    println(algorithms.cost(costes, greedy(0)._2))
//
//    val r = SH(Problem.a280, new Random)
//
//
//    println("Sol " + r._1)
//    println("iter " + r._2)
//    println(algorithms.cost(costes, r._1))





    for (i <- 1 to 5) {

      val file = new PrintWriter(new File(s"result_$i"))

      writeRow(file, "Ants")

      val Problem(size1, costes1, _, greedy1) = Problem.ch130
      val Problem(size2, costes2, _, greedy2) = Problem.a280
      val Problem(size3, costes3, _, greedy3) = Problem.p654

      SH.MaxTime = 5 minutes

      var s1 = SH(Problem.ch130, new Random(i))
      writeRow(file, s"$i -------- ch130 SH")
      writeRow(file, s"${s1._1}")
      writeRow(file, s"${s1._2}")
      writeRow(file, s"${algorithms.cost(costes1, s1._1)}")
      writeRow(file, s"---------------------------")

      println(s"sh130 $i")

      SH.MaxTime = 10 minutes

      var s2 = SH(Problem.a280, new Random(i))
      writeRow(file, s"$i -------- a280 SH")
      writeRow(file, s"${s2._1}")
      writeRow(file, s"${s2._2}")
      writeRow(file, s"${algorithms.cost(costes2, s2._1)}")
      writeRow(file, s"---------------------------")

      println(s"sh280 $i")

      SH.MaxTime = 15 minutes

      var s3 = SH(Problem.p654, new Random(i))
      writeRow(file, s"$i -------- p654 SH")
      writeRow(file, s"${s3._1}")
      writeRow(file, s"${s3._2}")
      writeRow(file, s"${algorithms.cost(costes3, s3._1)}")
      writeRow(file, s"---------------------------")

      writeRow(file, "===========================================================00")

      println(s"sh654 $i")


      SHE.MaxTime = 5 minutes

      s1 = SHE(Problem.ch130, new Random(i))
      writeRow(file, s"$i -------- ch130 SHE")
      writeRow(file, s"${s1._1}")
      writeRow(file, s"${s1._2}")
      writeRow(file, s"${algorithms.cost(costes1, s1._1)}")
      writeRow(file, s"---------------------------")

      println(s"SHE 130 $i")

      SHE.MaxTime = 10 minutes

      s2 = SHE(Problem.a280, new Random(i))
      writeRow(file, s"$i -------- a280 SHE")
      writeRow(file, s"${s2._1}")
      writeRow(file, s"${s2._2}")
      writeRow(file, s"${algorithms.cost(costes2, s2._1)}")
      writeRow(file, s"---------------------------")

      println(s"SHE 280 $i")

      SHE.MaxTime = 15 minutes

      s3 = SHE(Problem.p654, new Random(i))
      writeRow(file, s"$i -------- p654 SHE")
      writeRow(file, s"${s3._1}")
      writeRow(file, s"${s3._2}")
      writeRow(file, s"${algorithms.cost(costes3, s3._1)}")
      writeRow(file, s"---------------------------")

      writeRow(file, "===========================================================00")

      println(s"SHE 654 $i")

      SCH.MaxTime = 5 minutes

      s1 = SCH(Problem.ch130, new Random(i))
      writeRow(file, s"$i -------- ch130 SCH")
      writeRow(file, s"${s1._1}")
      writeRow(file, s"${s1._2}")
      writeRow(file, s"${algorithms.cost(costes1, s1._1)}")
      writeRow(file, s"---------------------------")

      println(s"SCH 130 $i")

      SHE.MaxTime = 10 minutes

      s2 = SCH(Problem.a280, new Random(i))
      writeRow(file, s"$i -------- a280 SCH")
      writeRow(file, s"${s2._1}")
      writeRow(file, s"${s2._2}")
      writeRow(file, s"${algorithms.cost(costes2, s2._1)}")
      writeRow(file, s"---------------------------")

      println(s"SCH 280 $i")

      SCH.MaxTime = 15 minutes

      s3 = SCH(Problem.p654, new Random(i))
      writeRow(file, s"$i -------- p654 SCH")
      writeRow(file, s"${s3._1}")
      writeRow(file, s"${s3._2}")
      writeRow(file, s"${algorithms.cost(costes3, s3._1)}")
      writeRow(file, s"---------------------------")

      println(s"SCH 654 $i")

      file.close()
    }


  }

  def writeRow(pw: PrintWriter, row: String) = {
    pw.write(row+"\n")
  }


}
