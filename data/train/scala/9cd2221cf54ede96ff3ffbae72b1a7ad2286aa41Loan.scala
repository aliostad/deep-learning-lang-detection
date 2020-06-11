/*
 * Copyright 2016 Vladimir Konstantinov, Yuriy Gintsyak
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.oxydev.korro.util.lang

/**
 * Scala implementation of <a href="https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html">
 * `try-with-resources`</a>.
 * {{{
 *   val line = loan (new BufferedReader(new FileReader(path))) to (_.readLine())
 * }}}
 *
 * @see http://illegalexception.schlichtherle.de/2012/07/19/try-with-resources-for-scala/
 */
object Loan {

  /**
   * One `AutoCloseable` resource.
   */
  def loan[A <: AutoCloseable](a: A) = new Loan1(a)

  /**
   * Two `AutoCloseable` resources.
   */
  def loan[A <: AutoCloseable, B <: AutoCloseable](a: A, b: B) = new Loan2(a, b)

  /**
   * Three `AutoCloseable` resources.
   */
  def loan[A <: AutoCloseable, B <: AutoCloseable, C <: AutoCloseable](a: A, b: B, c: C) = new Loan3(a, b, c)
}

sealed abstract class Loan {
  protected def manage[R](block: => R, resources: AutoCloseable*): R = {
    var t: Throwable = null
    try block catch {
      case e: Throwable => t = e; throw e
    } finally {
      resources.filter(_ != null) foreach { res =>
        try res.close() catch {
          case e: Throwable => if (t == null) t = e else t.addSuppressed(e)
        }
      }
    }
  }
}

class Loan1[A <: AutoCloseable](a: A) extends Loan {
  def and[B <: AutoCloseable](b: B): Loan2[A, B] = new Loan2(a, b)
  def to[R](block: A => R): R = manage(block(a), a)
}

class Loan2[A <: AutoCloseable, B <: AutoCloseable](a: A, b: B) extends Loan {
  def and[C <: AutoCloseable](c: C): Loan3[A, B, C] = new Loan3(a, b, c)
  def to[R](block: (A, B) => R) = manage(block(a, b), a, b)
}

class Loan3[A <: AutoCloseable, B <: AutoCloseable, C <: AutoCloseable](a: A, b: B, c: C) extends Loan {
  def to[R](block: (A, B, C) => R) = manage(block(a, b, c), a, b, c)
}
