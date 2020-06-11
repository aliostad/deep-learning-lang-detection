package stepdefs
 
import cucumber.api.PendingException
import cucumber.api.scala.{ScalaDsl, EN}
import org.scalatest.Matchers
 
class ManageActivityInventoryTest extends ScalaDsl with EN with Matchers {
 
  Given("""^the 'Activity Inventory' list contains the following entries:$"""){ (List<Task> tasks) =>
    throw new PendingException()
  }
 
  When("""^the user adds the "(*.?)" entry to the 'Activity Inventory' list$"""){ (entry:String) =>
    throw new PendingException()
  }
 
  Then("""^the "(*.?)" entry should be added at the top of the 'Activity Inventory' list$"""){ (entry:String) =>
    throw new PendingException()
  }
 
}
