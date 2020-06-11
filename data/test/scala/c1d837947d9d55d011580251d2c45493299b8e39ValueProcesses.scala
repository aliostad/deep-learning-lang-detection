/*
 * Copyright 2013 Choucri FAHED
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.qslib.fidl

trait ValueProcesses extends Common {

  type RandomVariable[T] = Seq[T]
  type ValueProcess[T] = Seq[RandomVariable[T]]

  /**
   * Create an infinite stream starting at `start` and incrementing by
   * step `step`.
   *
   * @param start the start value of the stream
   * @param step the increment value of the stream
   * @return the stream starting at value `start`.
   */
  final def streamFrom(start: Double, step: Double): Stream[Double] =
    Stream.cons(start, streamFrom(start + step, step))

  final def constProcess[T](x: T): ValueProcess[T] = Stream.continually(Seq(x))

  val dateProcess: ValueProcess[Date] = Stream.from(0).map(d => Seq(d))

  implicit final class ValueProcessOps[A](processA: ValueProcess[A]) {

    /**
     * Determines the number of time steps in a value process.
     * Only terminates for finite value processes.
     */
    def horizon = processA.length

    def mapWith[B](f: A => B): ValueProcess[B] = processA.map(_ map f)

    def zipWith[B, C](processB: ValueProcess[B])(f: (A, B) => C): ValueProcess[C] =
      processA zip processB map {
        case (rvA, rvB) => (rvA, rvB).zipped map f
      }

    def zipWithAll[B, C](processB: ValueProcess[B])(f: (A, B) => C): ValueProcess[C] =
      processA.zipAll(processB, Seq(), Seq()) map {
        case (rvA, rvB) => (rvA, rvB).zipped map f
      }

    def zipWith[B, C, D](processB: ValueProcess[B],
                         processC: ValueProcess[C])
                        (f: (A, B, C) => D): ValueProcess[D] =
      processA zip processB zip processC map {
        case ((rvA, rvB), rvC) => rvA zip rvB zip rvC map {
          case ((a, b), c) => f(a, b, c)
        }
      }
  }

  implicit final class BooleanValueProcess(process: ValueProcess[Boolean]) {

    /**
     * Only terminates for finite value processes.
     * @return True if every value in a value process is true, false otherwise.
     */
    def allTrue: Boolean = process.map(_.forall(x => x)).forall(x => x)

    def condProcess[A](truePr: ValueProcess[A], falsePr: ValueProcess[A]): ValueProcess[A] =
      process.zipWith(truePr, falsePr) {
        (cond, first, second) => if (cond) first else second
      }
  }

  implicit final class DoubleValueProcess(process: ValueProcess[Double]) {

    def expectedValue: Seq[Double] = {

      // Creates a binomial probability lattice
      val probabilityLattice: ValueProcess[Double] = {

        // Creates an infinite Pascal Triangle
        val pathCounts: ValueProcess[Int] = Stream.iterate(Seq(1)) {
          previous =>
            val lower = previous :+ 0
            val upper = 0 +: previous
            (lower, upper).zipped map (_ + _)
        }

        // Calculates probabilities for a slice of the lattice
        def probabilities(ps: ValueProcess[Int]): ValueProcess[Double] =
          if (ps.isEmpty) Nil
          else ps.head.map(n => n.toDouble / ps.head.sum) +: probabilities(ps.tail)

        probabilities(pathCounts)
      }

      def expectedValueRV(outcomes: RandomVariable[Double], probabilities: RandomVariable[Double]): Double =
        (outcomes, probabilities).zipped.map(_ * _).sum

      (process, probabilityLattice).zipped map expectedValueRV
    }

    def unary_- : ValueProcess[Double] = process.mapWith(-_)

    def +(otherProcess: ValueProcess[Double]): ValueProcess[Double] =
      process.zipWith(otherProcess)(_ + _)

    def -(otherProcess: ValueProcess[Double]): ValueProcess[Double] =
      process.zipWith(otherProcess)(_ - _)

    def *(otherProcess: ValueProcess[Double]): ValueProcess[Double] =
      process.zipWith(otherProcess)(_ * _)

    // Some mysterious compiler issue forbids calling this method 'min'
    def minimum(otherProcess: ValueProcess[Double]): ValueProcess[Double] =
      process.zipWith(otherProcess)(_ min _)

    // Some mysterious compiler issue forbids calling this method 'max'
    def maximum(otherProcess: ValueProcess[Double]): ValueProcess[Double] =
      process.zipWith(otherProcess)(_ max _)
  }

}
