/*
 * Copyright (C) 2015  Vladimir Konstantinov, Yuriy Gintsyak
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package io.cafebabe.util.lang

/**
 * TODO: Add description.
 *
 * @author Vladimir Konstantinov
 */
object Loan {
  def loan[A <: AutoCloseable](a: A): Loan1[A] = new Loan1(a)
}

/**
 * TODO: Add description.
 *
 * @author Vladimir Konstantinov
 */
sealed abstract class Loan {
  protected def manage[R](block: => R, resources: AutoCloseable*): R = {
    var t: Throwable = null
    try block catch {
      case e: Throwable => t = e; throw e
    } finally {
      resources.filter(_ != null) foreach { res =>
        try res.close() catch {
          case e: Throwable =>
            if (t == null) t = e
            else t.addSuppressed(e)
        }
      }
    }
  }
}

/**
 * TODO: Add description.
 *
 * @author Vladimir Konstantinov
 */
class Loan1[A <: AutoCloseable](a: A) extends Loan {
  def and[B <: AutoCloseable](b: B): Loan2[A, B] = new Loan2(a, b)
  def to[R](block: A => R): R = manage(block(a), a)
}

/**
 * TODO: Add description.
 *
 * @author Vladimir Konstantinov
 */
class Loan2[A <: AutoCloseable, B <: AutoCloseable](a: A, b: B) extends Loan {
  def and[C <: AutoCloseable](c: C): Loan3[A, B, C] = new Loan3(a, b, c)
  def to[R](block: (A, B) => R) = manage(block(a, b), a, b)
}

/**
 * TODO: Add description.
 *
 * @author Vladimir Konstantinov
 */
class Loan3[A <: AutoCloseable, B <: AutoCloseable, C <: AutoCloseable](a: A, b: B, c: C) extends Loan {
  def to[R](block: (A, B, C) => R) = manage(block(a, b, c), a, b, c)
}
