package in.emor.scalahub

import org.specs._

class UserSpec extends Specification {
  val user = new User("defunkt")
  "User" should {
    "show parameter" in {
      "show gravatar-id" in {
        user.show("gravatar-id") mustEqual "b8dbb1987e8e5318584865f880036796"
      }
      "show company" in {
        user.show("company") mustEqual "GitHub"
      }
      "show name" in {
        user.show("name") mustEqual "Chris Wanstrath"
      }
      "show created-at" in {
        user.show("created-at") mustEqual "2007-10-19T22:24:19-07:00"
      }
      "show location" in {
        user.show("location") mustEqual "San Francisco, CA"
      }
      "show public-repo-count" in {
        user.show("public-repo-count") mustEqual "97"
      }
      "show public-gist-count" in {
        user.show("public-gist-count") mustEqual "272"
      }
      "show blog" in {
        user.show("blog") mustEqual "http://chriswanstrath.com/"
      }
      "show following-count" in {
        user.show("following-count") mustEqual "207"
      }
      "show id" in {
        user.show("id") mustEqual "2"
      }
      "show type" in {
        user.show("type") mustEqual "User"
      }
      "show permission" in {
        user.show("permission") mustEqual "true"
      }
      "show followers-count" in {
        user.show("followers-count") mustEqual "1789"
      }
      "show login" in {
        user.show("login") mustEqual "defunkt"
      }
      "show email" in {
        user.show("email") mustEqual "chris@wanstrath.com"
      }
    }
  }
}
