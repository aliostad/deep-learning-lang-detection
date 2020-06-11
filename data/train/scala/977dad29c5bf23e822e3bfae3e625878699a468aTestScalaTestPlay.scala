package randomPlay

import core.dump.DumpObject
import core.dump.DumpObject._
import core.globals.KnowledgeGraphs
import core.testData.WikidataFactory
import org.scalatest.FunSuite
import tags.ActiveTag

import scala.collection.mutable.ListBuffer
import scala.util.matching.Regex.MatchIterator

/**
  * Created by espen on 16.03.17.
  */
class TestScalaTestPlay extends FunSuite{
  def fixture = new {
    val builder = new StringBuilder("Scala test is")
    val buffer = new ListBuffer[String]
  }
  test("testing fixture", ActiveTag) {
    val f = fixture
    f.builder.append(" easy")
    assertResult("Scala test is easy"){f.builder.toString()}
    assert(f.buffer.isEmpty)
    f.buffer.append("test")
    assert(f.buffer.nonEmpty)
  }
  test("fixture reset after previous test", ActiveTag) {
    val f = fixture
    assert(f.buffer.isEmpty)
  }
  test("iterating over null should work"){
    var eIsObject : (List[String], List[String]) = (Nil, Nil)
    for(a <- eIsObject._1) {
      println(a)
    }
  }
  test("fold left starts from head?") {
    val list = 1 to 9
    println(list.foldLeft(0){case(acc, nextValue) => {
      println(s"Next value $nextValue")
      acc + nextValue
    }})
  }
  val wd = WikidataFactory
  test("Abbreviate a name") {
    val rStarr = "Ringo Starr"
    val threeLettersFirstNameTwoLettersLastname = """(\w{3})[^\s]* (\w{2})""".r
    matchPrinter(rStarr)
    List(wd.ringoStarr.id, wd.countryProp, "Espen Albert").foreach(matchPrinter)
    threeLettersFirstNameTwoLettersLastname.findAllIn(rStarr) match {
      case a : MatchIterator if(a.nonEmpty) =>
        val listOfMatches = a.matchData.map(_.subgroups).toList
        println(listOfMatches);
      case _ => println("no match")
    }

  }

  private def matchPrinter(label: String) = {
    label.split(" ") match {
      case a: Array[String] if a.size < 5 && a.size > 2 => println(a.map(_.head.toUpper).mkString(""))
      case a: Array[String] if a.size < 3 && a.size > 1 => println(s"${a.head.take(3)}${a(1).take(2)}")
      case a if a.size == 1 => label match {
        case b if b.indexOf("P") > 0 => println(b.substring(b.indexOf("P")))
        case b if b.indexOf("Q") > 0 => println(b.substring(b.indexOf("Q")))
      }
      case _ => println(s"no match $label")
    }
  }
  test("Proper splitting of results" ){
    val errorCreator = "5134512F|5134113F"
    val shouldSplit = "normal | 5134113F"
    val splitted = errorCreator.split("""\s\|\s""")
    val splitted2 = shouldSplit.split("""\s\|\s""")
    println(splitted.mkString("\n"))
    println(splitted2.mkString("\n"))

  }
  trait HasEntity[T] {
    def hasEntity(v : T) : Boolean
  }
  class TestMeHasEntity(val b : Boolean)

//  abstract class Triple(val subject : String, val property: String, val objectValue: String)
//  case class OrdinaryTriple(override val subject : String, override val property: String, override val objectValue: String) extends Triple(subject, property, objectValue)


  def hasEntity[T: HasEntity](v : T) : Boolean = {
    implicitly[HasEntity[T]].hasEntity(v)
  }
  implicit object VMHasEntityMaker extends HasEntity[TestMeHasEntity] {
    def hasEntity(triple: TestMeHasEntity) : Boolean = {
      return triple.b
    }


//    override def hasEntity[T](v: T): Boolean =
//    {
//      v.asInstanceOf[TestMeHasEntity].b
//    }
  }
//  implicit object VMHasEntityMaker2 extends HasEntity[VMTriple] {
//    def hasEntity(v: VMTriple): Boolean = {
//      true
//    }
//  }

//  test("pattern matching on triples...") {
//    val ringoStarr = wd.ringoStarr
//    val rid = ringoStarr.id
//    val ordinary = OrdinaryTriple(rid, ringoStarr.memberOfProp, ringoStarr.memberOfValue)
//    val vmTriple = VMTriple(wd.johnLennon, ringoStarr.memberOfProp, ringoStarr.memberOfValue, (wd.johnLennon, rid), (ringoStarr.memberOfValue, 5))
//    val metallica = "Metallica"
//    val larsulrich = "LarsUlrich"
//    val tmTriple = TMTriple(larsulrich, ringoStarr.memberOfProp, metallica, (metallica, wd.rockBand, ringoStarr.memberOfValue)::Nil)
//    val triples = List(ordinary, vmTriple, tmTriple)
//    triples.collect{
//      case OrdinaryTriple(s,p,o) => println(s + "Probably doesn't work... cannot extend case class... ")
//      case VMTriple(s, p, o, (r,`rid`),_) => println("wow")
//      case TMTriple(s, p, o, r1::r2::_) if r1._3 == ringoStarr.memberOfValue=> println("wowx2")
//    }
//
//    println(hasEntity(vmTriple))
//    println(DumpObject.dumpListNewWay(triples))
//    val tripleFilename = "test-triple-dump"
//    DumpObject.dumpList[Triple](triples, tripleFilename)
//    val newTriples = DumpObject.getList[Triple](tripleFilename)
//    println(newTriples)
////    newTriples.collect{
////      case OrdinaryTriple(s,p,o) => println(s + "Probably doesn't work... cannot extend case class... ")
////      case VMTriple(s, p, o, (r,`rid`),_) => println("wow")
////      case TMTriple(s, p, o, repl) if repl.exists(_._3 == ringoStarr.memberOfValue)=> println("wowx2")
////    }
//    def **[T : Numeric](xs: Iterable[T], ys: Iterable[T]) =
//      xs zip ys map { t => implicitly[Numeric[T]].times(t._1, t._2) }
//
//    println(**(List(8), List(2)))
//
//  }
//  test("dump object a type parameterized list:"){
//    val l = List[String]("a", "b")
//    val filename = "testManifest"
//    DumpObject.dumpList(l, filename)
//    val l2 : List[String]= DumpObject.getList[String](filename)
//    println(s"Yes got $l2")
//    val lT = List[OrdinaryTriple](OrdinaryTriple("a", "b","c"))
//    DumpObject.dumpList[OrdinaryTriple](lT, filename)
//    val l2T = DumpObject.getList[OrdinaryTriple](filename)
//    println(s"Yes got $l2T")
//    val typeMap = l.zip(lT).toMap
//    DumpObject.dumpMap[String, OrdinaryTriple](typeMap, filename)
//    val rMap = DumpObject.readMap[String, OrdinaryTriple](filename)
//    val rMap2 = rMap.map(p => (p._1, List(p._2))).toMap
//    DumpObject.dumpMap[String, List[OrdinaryTriple]](rMap2, filename)
//    val rMap3 = DumpObject.readMap[String, List[OrdinaryTriple]](filename)
//    println(rMap3)
//
//  }

}
