package nju.seg.zhangyf.scala.otherExamples

import java.util.concurrent.atomic.{ AtomicInteger, AtomicReference, AtomicStampedReference }
import java.util.function.{ IntBinaryOperator, IntUnaryOperator, UnaryOperator }
import javax.annotation.ParametersAreNonnullByDefault

/**
  * @see http://www.infoq.com/cn/articles/java-memory-model-4/
  * @see http://blog.csdn.net/hsuxu/article/details/9467651
  * @author Zhang Yifan
  */
@ParametersAreNonnullByDefault
object CASTest {

  /*
     由于java的CAS同时具有 volatile 读和volatile写的内存语义，因此Java线程之间的通信现在有了下面四种方式：
      A线程写volatile变量，随后B线程读这个volatile变量。
      A线程写volatile变量，随后B线程用CAS更新这个volatile变量。
      A线程用CAS更新一个volatile变量，随后B线程用CAS更新这个volatile变量。
      A线程用CAS更新一个volatile变量，随后B线程读这个volatile变量。

    Java的CAS会使用现代处理器上提供的高效机器级别原子指令，这些原子指令以原子方式对内存执行读-改-写操作，
    这是在多处理器中实现同步的关键（从本质上来说，能够支持原子性读-改-写指令的计算机器，
    是顺序计算图灵机的异步等价机器，因此任何现代的多处理器都会去支持某种能对内存执行原子性读-改-写操作的原子指令）。
    同时，volatile变量的读/写和CAS可以实现线程之间的通信。把这些特性整合在一起，就形成了整个concurrent包得以实现的基石。
    如果我们仔细分析concurrent包的源代码实现，会发现一个通用化的实现模式：
      首先，声明共享变量为volatile；
      然后，使用CAS的原子条件更新来实现线程之间的同步；
      同时，配合以volatile的读/写和CAS所具有的volatile读和写的内存语义来实现线程之间的通信。
    AQS，非阻塞数据结构和原子变量类（java.util.concurrent.atomic包中的类），这些concurrent包中的基础类都是使用这种模式来实现的，
    而concurrent包中的高层类又是依赖于这些基础类来实现的。
   */

  def main(args: Array[String]): Unit = {

    // 首先，Java 的 volatile 变量，不仅保证线程间的可见性，也保证基本读写操作的原子性。(C++ 的 volatile 变量不保证基本读写操作的原子性)
    //    Volatile variables share the visibility features of synchronized, but none of the atomicity features.
    //    即 Volatile 具有 synchronized 的可见性特性，但不具有synchronized的原子性。
    //    但对任意单个volatile变量的读/写具有原子性。
    //    在《The Java Language Specification Java SE 7 Edition》的17.7章，有如下描述：
    //      a single write to a non-volatile long or double value is treated as two separate writes.
    //      Writes and reads of volatile long and double values are always atomic.
    //    也就是说，java语言规范不保证对long或double的写入具有原子性。
    //    但当我们把 long或double声明为volatile后，对这个变量的写将具有原子性了。
    //
    // @volatile var value: Int = 0

    // basic usage
    def usage1(value: AtomicInteger): Unit = {
      var oldValue, newValue = 0
      do {
        oldValue = value.get
        // do staff
        newValue = oldValue + 10
      } while (!value.compareAndSet(oldValue, newValue))

      // or use other methods in Atomic instances

      val oldValue1 = value.getAndAdd(10)

      val oldValue2 = value.getAndUpdate(new IntUnaryOperator {
        override def applyAsInt(operand: Int): Int = operand + 10
      })

      val updateValue = 10
      val oldValue3 = value.getAndAccumulate(updateValue, new IntBinaryOperator {
        override def applyAsInt(left: Int, right: Int): Int = {
          assert(right == updateValue)
          left + right * 10
        }
      })

      val newValue1 = value.addAndGet(10)
    }

    final case class ComposeClass(i: Int, j: String)

    def usage2(): Unit = {
      /*
       CAS 只能保证一个共享变量的原子操作。当对一个共享变量执行操作时，我们可以使用循环CAaS的方式来保证原子操作，
       但是对多个共享变量操作时，循环CAS就无法保证操作的原子性，这个时候就可以用锁，或者有一个取巧的办法，就是把多个共享变量合并成一个共享变量来操作。
       比如有两个共享变量i＝2,j=a，合并一下ij=2a，然后用CAS来操作ij。
       从Java1.5开始JDK提供了AtomicReference类来保证引用对象之间的原子性，你可以把多个变量放在一个对象里来进行CAS操作。
       */

      val value = new AtomicReference(ComposeClass(1, "a"))

      val oldValue = value.getAndUpdate(new UnaryOperator[ComposeClass] {
        override def apply(t: ComposeClass): ComposeClass = ComposeClass(t.i + 1, t.j + "a")
      })
    }

    // DCAS usage
    def usage3(value: AtomicStampedReference[ComposeClass]): Unit = {
      /*
       ABA问题。因为CAS需要在操作值的时候检查下值有没有发生变化，如果没有发生变化则更新，但是如果一个值原来是A，变成了B，又变成了A，
       那么使用CAS进行检查时会发现它的值没有发生变化，但是实际上却变化了。
       ABA问题的解决思路就是使用版本号。在变量前面追加上版本号，每次变量更新的时候把版本号加一，那么A－B－A 就会变成1A-2B－3A。
       从Java1.5开始JDK的atomic包里提供了一个类AtomicStampedReference来解决ABA问题。
       这个类的compareAndSet方法作用是首先检查当前引用是否等于预期引用，并且当前标志是否等于预期标志，如果全部相等，则以原子方式将该引用和该标志的值设置为给定的更新值。

       关于ABA问题参考文档: http://blog.hesey.net/2011/09/resolve-aba-by-atomicstampedreference.html
       */

      var oldValue, newValue = null.asInstanceOf[ComposeClass]
      // notice in Scala the value of oldStamp will be 0, while in Java or C++ the value will be uninitialized
      var oldStamp, newStamp = 0
      do {
        oldValue = value.getReference
        oldStamp = value.getStamp

        // do staff and update stamp
        newValue = ComposeClass(oldValue.i + 1, oldValue.j + "a")
        newStamp = oldStamp + 1
      }
      while (!value.compareAndSet(oldValue, newValue, oldStamp, newStamp))
    }
  }
}
