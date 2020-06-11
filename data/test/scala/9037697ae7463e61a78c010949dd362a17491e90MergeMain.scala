package jp.seraphr.practice.expr.problem.merge

object MergeMain {

  def main(args: Array[String]): Unit = {
    object MergeSubAndShow extends MergeSubAndShow
    object CalculateImpls extends MergeSubAndShow.CalculateImpls
    object ShowImpls extends MergeSubAndShow.ShowImpls
    import MergeSubAndShow._
    import CalculateImpls._
    import ShowImpls._
    import language.reflectiveCalls

    val tNode = ValueNode(10) -- ValueNode(5)
    println(show(tNode) + " = " + calc(tNode)) // => (10 - 5) = 5

    val tNode2 = ValueNode(5) ++ ValueNode(4) -- ValueNode(2)
    println(show(tNode2) + " = " + calc(tNode2)) // => (5 + 4 - 2) = 7

    val tNode3 = ValueNode(5) -- (ValueNode(4) -- ValueNode(2))
    println(show(tNode3) + " = " + calc(tNode3)) // => (5 - (4 - 2)) = 3
  }
}