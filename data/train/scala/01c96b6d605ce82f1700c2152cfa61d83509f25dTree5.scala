sealed abstract class TreeNode
case class NamedNode(left: TreeNode, right: TreeNode, name: String) extends TreeNode
case class Node(left: TreeNode, right: TreeNode) extends TreeNode
case class Leaf(data: Int) extends TreeNode

object Tree5 {
  val l1 = new Leaf(1)
  val l2 = new Leaf(2)
  val l3 = new Leaf(3)
  val l4 = new Leaf(4)
  val root = new NamedNode(new Node(l1, l2), new Node(l3, l4), "root")

  def dump(t: TreeNode): String = {
    t match {
      case NamedNode(l, r, n) => n + " -> left(" + dump(l) + "):right(" + dump(r) + ")"
      case Node(l, r) => "left(" + dump(l) + "):right(" + dump(r) + ")"
      case Leaf(d) => d.toString
    }
  }
}
