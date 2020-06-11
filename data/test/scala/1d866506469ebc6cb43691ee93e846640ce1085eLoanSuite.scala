package com.github.loanptn

import org.mockito.Mockito._
import org.scalatest.FunSuite
import org.scalatest.matchers.ShouldMatchers
 
class LoanSuite extends FunSuite with ShouldMatchers {
  import java.io.{Closeable => JCloseable, _}
  type Closeable = { def close() }
  test("usingが正常に使用できる") {
    val res = mock(classOf[InputStream])
    using[Unit, JCloseable](res) { res =>
      verify(res, never()).close()
    }
    verify(res, times(1)).close()
  }
  test("manageが正常に使用できる") {
    import java.io._
    val res = mock(classOf[InputStream])
    for(in <- manage(res)) {
      verify(res, never()).close()
    }
    verify(res, times(1)).close()
  }
  test("manageが正常に使用できる(その2)") {
    import java.io._
    val res = mock(classOf[InputStream])
    val res2 = mock(classOf[InputStream])
    for(in <- manage(res);
        in2 <- manage(res2)) {
      verify(res, never()).close()
      verify(res2, never()).close()
    }
    val inOrd = inOrder(res, res2)
    inOrd.verify(res2, times(1)).close()
    inOrd.verify(res, times(1)).close()
  }

  test("manageが正常に使用できる(その3)") {
    import java.io._
    class InputStreamMock(value: Int) extends InputStream {
      def read() = value
    }
    val res = spy(new InputStreamMock(5))
    val res2 = spy(new InputStreamMock(7))
    val x = for(in <- manage(res);
        in2 <- manage(res2)) yield {
      verify(res, never()).close()
      verify(res2, never()).close()
      (res.read, res2.read)
    }
    x() should be (5, 7)
    val inOrd = inOrder(res, res2)
    inOrd.verify(res2, times(1)).close()
    inOrd.verify(res, times(1)).close()
  }

  test("flatMapが合成できる") {
    import java.io._
    class InputStreamMock(value: Int) extends InputStream {
      def read() = value
    }
    val res = spy(new InputStreamMock(5))
    val x = for(in <- manage(res)) yield {
      verify(res, never()).close()
      res.read
    }
    val res2 = spy(new InputStreamMock(7))

    verify(res, never()).close()
    val y = for(x_val <- x;
        in <- manage(res2)) yield {
      verify(res, times(1)).close()
      verify(res2, never()).close()
      (x_val, res2.read)
    }

    y() should be (5, 7)
    x() should be (5)
    val inOrd = inOrder(res, res2)
    inOrd.verify(res, times(1)).close()
    inOrd.verify(res2, times(1)).close()
  }

  test("flatMapが合成できる(その2)") {
    import java.io._
    class InputStreamMock(value: Int) extends InputStream {
      def read() = value
    }
    val res = spy(new InputStreamMock(5))
    val x = for(in <- manage(res)) yield {
      verify(res, never()).close()
      res.read
    }
    x() should be (5)
    val res2 = spy(new InputStreamMock(7))

    verify(res, times(1)).close()
    val y = for(x_val <- x;
        in <- manage(res2)) yield {
      verify(res, times(1)).close()
      verify(res2, never()).close()
      (x_val, res2.read)
    }

    y() should be (5, 7)
    val inOrd = inOrder(res, res2)
    inOrd.verify(res, times(1)).close()
    inOrd.verify(res2, times(1)).close()
  }
  test("flatMapが合成できる(その3)") {
    import java.io._
    class InputStreamMock(value: Int) extends InputStream {
      def read() = value
    }
    val res = spy(new InputStreamMock(5))
    val x = for(in <- manage(res)) yield {
      verify(res, never()).close()
      res.read
    }
    val res2 = spy(new InputStreamMock(7))

    verify(res, never()).close()
    val y = for(in <- manage(res2);
                x_val <- x) yield {
      verify(res, times(1)).close()
      verify(res2, never()).close()
      (x_val, res2.read)
    }

    y() should be (5, 7)
    val inOrd = inOrder(res, res2)
    inOrd.verify(res, times(1)).close()
    inOrd.verify(res2, times(1)).close()
  }

  test("Monad則を満たす") {
    import java.io._
    class InputStreamMock(value: Int) extends InputStream {
      def read() = value

      override def equals(o: Any) = o match {
        case other: InputStreamMock => this.read == other.read
      }
    }
    def unit[R](res: R)(implicit resourceCleaner: ResourceCleaner[R]) = manage(res)(resourceCleaner)
    def create(i: Int) = new InputStreamMock(i)
    def f(i: InputStreamMock) = unit(create(i.read() * 3))

    assert( unit(create(5)).flatMap(f) == f(create(5)) )

    assert( unit(create(5)).flatMap(manage(_)) == unit(create(5)) )
    def g(i: InputStreamMock) = unit(create(i.read() * 7))

    assert( unit(create(5)).flatMap(f).flatMap(g) == unit(create(5)).flatMap(f(_).flatMap(g)) )
  }

  test("OutputStreamでmanageが正常に使用できる") {
    import java.io._
    var res = mock(classOf[OutputStream])
    for(in <- manage(res)) {
      verify(res, never()).close()
    }
    verify(res, times(1)).close()
  }

  test("Sourceでmanageが正常に使用できる") {
    import scala.io._
    var res = mock(classOf[Source])
    for(in <- manage(res)) {
      verify(res, never()).close()
    }
    verify(res, times(1)).close()
  }

  test("Connectionでmanageが正常に使用できる") {
    import java.sql._
    var res = mock(classOf[Connection])
    for(in <- manage(res)) {
      verify(res, never()).close()
    }
    verify(res, times(1)).close()
  }

  test("Statementでmanageが正常に使用できる") {
    import java.sql._
    var res = mock(classOf[Statement])
    for(in <- manage(res)) {
      verify(res, never()).close()
    }
    verify(res, times(1)).close()
  }

  test("PreparedStatementでmanageが正常に使用できる") {
    import java.sql._
    var res = mock(classOf[PreparedStatement])
    for(in <- manage(res)) {
      verify(res, never()).close()
    }
    verify(res, times(1)).close()
  }

  test("ResultSetでmanageが正常に使用できる") {
    import java.sql._
    var res = mock(classOf[ResultSet])
    for(in <- manage(res)) {
      verify(res, never()).close()
    }
    verify(res, times(1)).close()
  }

}
