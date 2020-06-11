package jp.seraphr.practice.expr.problem.addshow

object AddShowMain {

  def main(args: Array[String]): Unit = {
    object AddShow extends AddShow
    object CalculateImples extends AddShow.CalculateImpls
    object ShowImples extends AddShow.ShowImpls
    import AddShow._
    import CalculateImples._
    import ShowImples._
    import language.reflectiveCalls

    val tNode = AddNode(ValueNode(1), AddNode(AddNode(ValueNode(2), ValueNode(3)), ValueNode(4)))
    println(show(tNode) + " = " + calc(tNode)) // => 1 + 2 + 3 + 4 = 10

    val tNode2 = ValueNode(1) ++ (ValueNode(2) ++ ValueNode(10))
    println(show(tNode2) + " = " + calc(tNode2)) // => 1 + 2 + 10 = 13
  }
}