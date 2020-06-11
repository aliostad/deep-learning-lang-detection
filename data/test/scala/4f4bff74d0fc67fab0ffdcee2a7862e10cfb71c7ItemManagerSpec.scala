package manage

import main.domain.Apple
import org.specs2.mutable.Specification

class ItemManagerSpec extends Specification {

  val itemManager = new ItemManager

  "find item" should {
    "convert Apple to an Apple object" in {
      itemManager.findItem("Apple") mustEqual(Some(Apple))
    }

    "convert lowercase apple to an Apple object" in {
      itemManager.findItem("apple") mustEqual(Some(Apple))
    }

    "return None when item does not exist in list of available items" in {
      itemManager.findItem("Car") mustEqual(None)
    }
  }

}
