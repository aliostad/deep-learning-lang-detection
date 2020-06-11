package dynamo.ast.writes

import dynamo.ast._
import org.specs2.{ScalaCheck, Specification}

class CollectionWriteTest  extends Specification with ScalaCheck { def is = s2"""
 Specification for the collection writes
  Writing a List should yield a L $writeList

  Writing a Set[String] should yield a SS $writeSetString
  Writing a Set[Int] should yield a NS $writeSetInt
  Writing a Set[Short] should yield a NS $writeSetShort
  Writing a Set[Float] should yield a NS $writeSetFloat
  Writing a Set[Long] should yield a NS $writeSetLong
  Writing a Set[Double] should yield a NS $writeSetDouble

  Writing a Map[String, String] should yield a M $writeMap
"""

  def writeList = prop { list: List[String] =>
    DynamoWrite[List[String]].write(list) should beLike {
      case L(elements) => elements.length should_== list.length
      case e => ko(s"Expected to be L got $e")
    }
  }

  def writeSetString = prop { set: Set[String] =>
    DynamoWrite[Set[String]].write(set) should beLike {
      case SS(elements) => elements.size should_== set.size
      case e => ko(s"Expected to be SS got $e")
    }
  }

  def writeSetInt = prop { set: Set[Int] =>
    DynamoWrite[Set[Int]].write(set) should beLike {
      case NS(elements) => elements.size should_== set.size
      case e => ko(s"Expected to be NS got $e")
    }
  }

  def writeSetShort = prop { set: Set[Short] =>
    DynamoWrite[Set[Short]].write(set) should beLike {
      case NS(elements) => elements.size should_== set.size
      case e => ko(s"Expected to be NS got $e")
    }
  }

  def writeSetFloat = prop { set: Set[Float] =>
    DynamoWrite[Set[Float]].write(set) should beLike {
      case NS(elements) => elements.size should_== set.size
      case e => ko(s"Expected to be NS got $e")
    }
  }

  def writeSetLong = prop { set: Set[Long] =>
    DynamoWrite[Set[Long]].write(set) should beLike {
      case NS(elements) => elements.size should_== set.size
      case e => ko(s"Expected to be NS got $e")
    }
  }

  def writeSetDouble = prop { set: Set[Double] =>
    DynamoWrite[Set[Double]].write(set) should beLike {
      case NS(elements) => elements.size should_== set.size
      case e => ko(s"Expected to be NS got $e")
    }
  }

  def writeMap = prop { map: Map[String, String] =>
    DynamoWrite[Map[String, String]].write(map) should beLike {
      case M(elements) => elements.length should_== map.size
      case e => ko(s"Expected to be M got $e")
    }
  }

}
