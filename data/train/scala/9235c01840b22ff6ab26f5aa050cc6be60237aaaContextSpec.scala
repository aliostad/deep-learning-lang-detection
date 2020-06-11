package interpreter

import models._
import org.scalatest.{FlatSpec, Matchers}

class ContextSpec extends FlatSpec with Matchers {

  trait Env {
    val fakeRoutine = Routine("fake")
    val ctx = new Context(InstructionPointer(fakeRoutine, 0))

    val x = LocalVariable("x")
    val v = IntValue(42)
  }

  "Context" should "store local variables" in new Env {
    ctx.set(x, v)
    ctx.get(x) should be(v)
  }

  it should "delegate to parent context" in new Env {
    ctx.set(x, v)
    val child = new Context(InstructionPointer(fakeRoutine, 0), parent = Some(ctx))

    child.get(x) should be(v)
  }

  it should "manage stack" in new Env {
    ctx.pop should be(None)
    ctx.push(v)
    ctx.pop should be(Some(v))
    ctx.pop should be(None)
  }
}
