package scalaspec.serialization

import org.scalatest.Matchers._
import org.scalatest._

class SerializationSpec extends FunSpec {
  describe("Serialization") {
    it("serialize into string using context bound") {
      import ctxt.RemoteConnection

      RemoteConnection.write(100) should be("100")
      RemoteConnection.write(3.14f) should be("3.14")
      RemoteConnection.write("hello") should be("hello")
    }

//    it("serialize into string using view bound") {
//      import view.RemoteConnection
//
//      RemoteConnection.write(100) should be("100")
//      RemoteConnection.write(3.14f) should be("3.14")
//      RemoteConnection.write("hello") should be("hello")
//    }
  }
}
