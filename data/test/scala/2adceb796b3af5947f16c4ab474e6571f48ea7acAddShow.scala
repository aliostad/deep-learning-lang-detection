package jp.seraphr.practice.expr.problem.addshow

import jp.seraphr.practice.expr.problem.base.BaseNodes

trait AddShow extends BaseNodes {
  trait Show[_N] {
    def apply(aNode: _N): String
  }

  def show[_N: Show](aNode: _N): String = {
    implicitly[Show[_N]].apply(aNode)
  }

  trait ShowImpls {
    implicit object ShowValue extends Show[ValueNode] {
      override def apply(aNode: ValueNode): String = aNode.value.toString
    }

    implicit def ShowAdd[_L: Show, _R: Show] = new Show[AddNode[_L, _R]] {
      override def apply(aNode: AddNode[_L, _R]) = "%s + %s".format(show(aNode.left), show(aNode.right))
    }
  }
}