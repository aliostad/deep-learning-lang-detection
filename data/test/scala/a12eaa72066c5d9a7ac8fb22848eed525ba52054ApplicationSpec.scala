package test

import org.specs2.mutable._

import play.api.test._
import play.api.test.Helpers._

/**
 * Add your spec here.
 * You can mock out a whole application including requests, plugins etc.
 * For more information, consult the wiki.
 */
class ApplicationSpec extends Specification {
  
  "Application" should {
    
    "send 404 on a bad request" in {
      running(FakeApplication()) {
        route(FakeRequest(GET, "/boum")) must beNone        
      }
    }
    
    "render the index page" in {
      running(FakeApplication()) {
        val home = route(FakeRequest(GET, "/")).get
        
        status(home) must equalTo(OK)
        contentType(home) must beSome.which(_ == "text/html")
        contentAsString(home) must contain ("Your new application is ready.")
      }
    }

    "should be able to get new positions" in {
      val original = List("one", "two", "three")
      val hotnspicy = List("three", "two", "four", "one")

      case class Delta(name: String, movement: String)
      def generateDelta(old: List[String], replacement: List[String]) = {
        replacement.zipWithIndex.map{case(key, i) =>
          val oldIndex = old.indexOf(key)

          if (oldIndex == -1) {
            Delta(key, "new!")
          } else if (i < oldIndex ){
            Delta(key, "+"+(oldIndex - i))
          } else if (oldIndex < i) {
            Delta(key, (oldIndex - i).toString)
          } else {
            Delta(key, "<->")
          }
        }
      }

      generateDelta(original, hotnspicy) === List(
        Delta("three", "+2"),
        Delta("two", "<->"),
        Delta("four", "new!"),
        Delta("one", "-3"))


    }
  }
}