package tsp

import org.scalacheck._
import Prop.forAll
import scala.util.Random

/**
 * Created by Aleksey on 22/03/14.
 */
object SolverSpec extends Properties("Properties for methods in solvers") with DataGen {

  property("swapping entire array is equal to reversing it") = forAll {
    x: Array[Int] =>
      val old = x.clone()
      GenericOps.swap(-1, x.length, x)
      x.toList == old.reverse.toList
  }

  property("swapping subsequence") = forAll {
    x: Array[Int] =>
      val old = x.clone()
      val n = Random.nextInt(x.length + 1)
      GenericOps.swap(-1, n, x)
      x.toList.take(n) == old.toList.take(n).reverse
  }

  property("Intersected lines should intersect") = forAll(intersectedLines) {
    x => GenericOps.intersects(x._1, x._2, x._3, x._4)
  }

  property("Distance matrix should have all 0 diagonal") = forAll(graphPlots) {
    x =>
      val matrix = new DistanceMatrix(x._1, x._2)
      (0 to x._1 - 1).forall(y => math.abs(matrix(y, y)) < 0.0001)
  }

}
