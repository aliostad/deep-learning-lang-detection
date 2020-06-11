package ControllerSpec

import org.scalatestplus.play._
import play.api.test.Helpers._
import play.api.test._

class ManageControllerSpec extends PlaySpec with OneAppPerTest {


  "manageMentArea in ManageController" should {

    "render the management page" in {
      val signup = route(app, FakeRequest(GET, "/manage")).get

      status(signup) mustBe OK
      contentType(signup) mustBe Some("text/html")
      contentAsString(signup) must include("This is Management Page")
    }
  }

  "SuspendUser in SigningupControllerMethod" should {

    "redirect to the manage page" in {
      val result = route(app, FakeRequest(GET,"/suspend")).get
      status(result) equals 303
    }
  }
  "resumeUser in ManagementController" should {

    "redirect to the manage page" in {
      val result = route(app, FakeRequest(GET,"/resume")).get
      status(result) equals 303
    }
  }


}