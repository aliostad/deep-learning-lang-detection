package ilc
package util
package process

import org.scalatest.FunSuite

// Testing process abstracted as (partial) functions String => String
// should work on Mac and Windows
// (please report platform-dependent errors)

class FunProcessSuite extends FunSuite{
  test("hello world") {
    val helloWorld = "hello world"
    assert(FunProcess("echo", helloWorld)("").trim === helloWorld)
  }

  test("failed process should raise error") {
    val unexpectedCmd = "zo129kv78j2cx"
    import java.io.IOException
    intercept[IOException] { FunProcess(unexpectedCmd)("") }
    intercept[IOException] { FunProcess("")("") }
  }
}
