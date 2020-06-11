package macrospike

import concurrent.Future

object Demo extends App {
  object OldScalatraApp extends OldScalatra {
    get("/dummy") {
      Future {
        println(s"old request  = ${request}")
      }
    }
  }

  object NewScalatraApp extends NewScalatra {

    def get(int: Int)(action: => Any) {}

    // This shouldn't compile, but does ... we had to hardcode method names
    get(42)(request)

    // Rightfully does not compile
    // def ctype = request.contentType

    get("/dummy") {
      def foo = request.hashCode()
      Future {
        println(s"new request  = ${request}")
        println(s"content type = ${contentType}")
      }
    }
  }

  println("Old")
  OldScalatraApp.handle(new Request("html"), new Response)
  println("New")
  NewScalatraApp.handle(new Request("html"), new Response)
}




