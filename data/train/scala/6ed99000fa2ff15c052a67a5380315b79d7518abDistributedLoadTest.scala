import org.scalatest.{FlatSpec, Matchers}

import scala.concurrent.Future

/**
  * Created by feliperojas on 11/13/16.
  */
class DistributedLoadTest extends FlatSpec with Matchers {

  behavior of "distributed load"

  it should "call all nodes for a distributed test" in {
    DistributedLoad.load(Seq.empty) should be(Seq.empty)
    DistributedLoad.load(Seq(Node("localhost", 8000), Node("localhost", 8000))) should be(List(Load(Node("localhost", 8000)), Load(Node("localhost", 8000))))
  }

  case class Node(host: String, port: Int)

  case class Load(node: Node)

  case class LoadResult(values: String)

  object DistributedLoad {
    def load(nodes: Seq[Node]): Seq[Future[LoadResult]] = ???
  }

}
