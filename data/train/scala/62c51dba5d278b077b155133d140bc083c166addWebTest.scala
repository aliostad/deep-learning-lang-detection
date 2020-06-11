package feature

import com.twitter.finagle.http.Request
import com.twitter.finagle.http.Status.Ok
import env.RunningTestEnvironment
import io.fintrospect.ContentTypes
import org.scalatest.{FunSpec, Matchers}

class WebTest extends FunSpec with Matchers with RunningTestEnvironment {

  it("homepage") {
    val response = env.responseTo(Request("/"))
    response.status shouldBe Ok
    response.contentType.startsWith(ContentTypes.TEXT_HTML.value) shouldBe true
  }

  it("manage users") {
    val response = env.responseTo(Request("/users"))
    response.status shouldBe Ok
    response.contentType.startsWith(ContentTypes.TEXT_HTML.value) shouldBe true
  }
}
