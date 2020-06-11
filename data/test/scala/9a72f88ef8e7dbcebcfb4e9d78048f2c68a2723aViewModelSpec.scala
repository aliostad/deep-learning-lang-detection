import org.denigma.graphs.viewmodels.NodeViewModel
import org.denigma.graphs.{SG, SemanticGraph}
import SG._
import com.tinkerpop.blueprints._
import org.denigma.graphs.{SemanticGraph, SG}
import org.junit.runner._
import org.specs2.runner._
import play.api.test._
import scala.collection.JavaConversions._


@RunWith(classOf[JUnitRunner])
class ViewModelSpec extends SemanticSpec {


  "HyperEdge" should {
    val learn = "learn"
    val manage = "manage"
    val discover = "discover"
    val discStr = "discoveries"
    val peopleStr = "people"
    val wonder = "wonderer"

    def prepareTest = {
      val sg: SemanticGraph = prepareGraph

      val root = sg.root(sg.ROOT, NAME -> sg.ROOT, "other" -> "otherval")

      root.addLink(learn, "name" -> learn)
      val people = sg.addNode(NAME -> peopleStr)
      val m = root.addLinkTo(manage, people, "name" -> manage)
      val discoveries = sg.addNode(NAME -> discStr)
      val d: Vertex = root.addGetLinkTo(discover, discoveries, "name" -> discover)
      val dd: Vertex = root.addGetLinkTo(discover, discoveries)

      val indexes = sg.indexes
      val w =  sg.addNode(NAME -> wonder)
      w.setProperty("age",5000)
      w.setProperty("capital",12345.12345)
      w.setProperty("immortal",true)



      w ~> discover ~> discoveries
      w ~> manage ~> people
      sg.g.commit()
      sg
    }

    "equals" in new WithApplication {
      val sg = prepareTest

      import SG._

      val rr = sg.root
      val nw1: Option[Vertex] = sg.names.get(sg.NAME,wonder).headOption
//      val nw1: Option[Vertex] = sg.nodeByName(wonder)
        nw1 must not beNone
        val nw2: Option[Vertex] = sg.names.get(sg.NAME, wonder).headOption
//      val nw2: Option[Vertex] = sg.nodeByName(wonder)
        nw2 must not beNone

      val wonderer1 = nw1.get
      val wonderer2 = nw2.get

      wonderer1.id shouldEqual wonderer2.id
      //wonderer1 shouldNotEqual wonderer2

      val ew1 = new NodeViewModel(wonderer1)
      val ew2 = new NodeViewModel(wonderer2)
      ew1 shouldEqual ew2


      sg.g.shutdown()
    }

    "string propos" in new WithApplication {
      val sg = prepareTest

      import SG._

      val wonderer = sg.nodeByName(wonder).get
      wonderer.toStr(NAME).get shouldEqual wonder
      wonderer.toStr("age").get shouldEqual "5000"
      wonderer.toStr("capital").get shouldEqual "12345.12345"
      wonderer.toStr("immortal").get shouldEqual (true.toString)



      val ew = new NodeViewModel(wonderer)
      ew.properties.size shouldEqual 5
      ew.properties(ID) shouldEqual wonderer.id

      wonderer.id shouldEqual ew.id

      ew.properties(NAME) shouldEqual wonder
      ew.properties("age") shouldEqual  5000
      ew.properties("capital") shouldEqual 12345.12345
      ew.properties("immortal") shouldEqual true

      sg.g.shutdown()
    }
  }

}


