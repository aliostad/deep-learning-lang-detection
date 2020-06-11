
import org.denigma.graphs.schemes._
import org.denigma.graphs.schemes.constraints.{IntegerOf, DateTimeOf, TextOf, StringOf}

import org.denigma.graphs.{SemanticGraph, SG, Link}
import org.specs2.runner._
import org.junit.runner._
import scala.collection.JavaConversions._
import play.api.test._
import play.Play
import com.tinkerpop.blueprints._

/*
A test to test how types work
 */
@RunWith(classOf[JUnitRunner])
class SchemaSpec extends SemanticSpec {


  val learn = "learn"
  val manage = "manage"
  val discover = "discover"
  val discStr = "discoveries"
  val peopleStr = "people"

  def prepareTest = {
    val sg: SemanticGraph = prepareGraph
    import SG._

    val root = sg.root(sg.ROOT, NAME -> sg.ROOT, "other" -> "otherval")

    root.addLink(learn, "name" -> learn)
    val people = sg.addNode(NAME -> peopleStr)
    val m = root.addLinkTo(manage, people, "name" -> manage)
    val discoveries = sg.addNode(NAME -> discStr)
    val d: Vertex = root.addGetLinkTo(discover, discoveries, "name" -> discover)
    val dd: Vertex = root.addGetLinkTo(discover, discoveries)
    sg.g.commit()
    sg
  }

  "Schema" should {
    val learn = "learn"
    val manage = "manage"
    val discover="discover"
    val discStr = "discoveries"
    val peopleStr="people"

    "Add types" in new WithApplication{
      Play.application().isTest must beTrue
      val sg = prepareTest
      val g = sg.g


      g.shutdown()
    }

    }

  "verify a link" in new WithApplication{

    val sg = prepareTest
    import SG._



    object One extends LinkType("one")
    {
      val one = must be IntegerOf("one")
    }

    object Two extends LinkType("two"){

      val two = must be IntegerOf("two")

    }
    object Root extends NodeType("test")
    {
      val one = must be OutLinkOf("one",typeOfLink = One.name)
      val two = must be OutLinkOf("two", typeOfLink = Two.name)
    }
    sg.allTypes.contains(One) must beFalse
    sg.allTypes.contains(Two) must beFalse

    sg.registerType(One)
    sg.registerType(Two)
    sg.commit("One and Two types")
    sg.allTypes.contains(One.name) must beTrue
    sg.allTypes.contains(Two.name) must beTrue


    import SG._

    val rr = sg.root(sg.ROOT, NAME -> sg.ROOT, "other" -> "otherval")
    sg.g.commit()



    val pT = sg.names.get(sg.NAME,peopleStr).headOption.get
    val one = Link(One.name,from = rr.id, to = pT.id,types=One.name::Nil,props=Map("tone" -> 1))
    val two = Link(Two.name, from= rr.id, to = pT.id,props=Map("two" -> 2),types=Two.name::Nil)

    Root.one.isDirectedRight(one,rr) must beTrue
    Root.one.isDirectedRight(one, pT) must beFalse
    Root.one.fitsLinkType(one) must beTrue
    Root.one fitsLinkType(two) must beFalse
    Root.one.isValid(one,rr) must beTrue
    Root.one.isValid(one,pT) must beFalse
    Root.one.isValid(two,rr) must beFalse

    Root.two.isValid(one,rr) must beFalse
    Root.two.isValid(two,rr) must beTrue
    Root.must.linksValid(one::Nil,rr.id) must beFalse
    Root.must.linksValid(two::Nil,rr.id) must beFalse



    Root.must.linksValid(one::two::Nil,rr.id) must beTrue





    sg.g.shutdown()


  }

}
