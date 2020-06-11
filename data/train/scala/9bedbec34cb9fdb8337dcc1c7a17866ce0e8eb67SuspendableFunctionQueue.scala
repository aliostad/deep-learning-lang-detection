/*
 * Copyright 2012 杨博 (Yang Bo)
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

package com.dongxiguo.commons.continuations

import scala.util.continuations._

import SuspendableFunctionQueue._
import java.util.concurrent.atomic.AtomicReference

object SuspendableFunctionQueue {
  type Task = () => _ @suspendable

  def enquene(task: Task)(origin: List[Task]): List[Task] = {
    task :: origin
  }

  sealed abstract class State

  final case object Idle extends State

  final case object ShuttedDown extends State

  final case class Running(tasks: List[Task]) extends State

  final case class ShuttingDown(tasks: List[Task]) extends State
}

class SuspendableFunctionQueue extends AtomicReference[State](Idle) {

  private def takeMore() {
    get match {
      case old @ Running(Nil) => {
        if (!compareAndSet(old, Idle)) {
          return takeMore()
        }
      }
      case old @ Running(tasks) => {
        if (compareAndSet(old, Running(Nil))) {
          reset {
            val i = tasks.reverseIterator
            while (i.hasNext) {
              i.next()()
            }
            takeMore()
          }
        } else {
          return takeMore()
        }
      }
      case old @ ShuttingDown(Nil) => {
        if (!compareAndSet(old, ShuttedDown)) {
          return takeMore()
        }
      }
      case old @ ShuttingDown(tasks) => {
        if (compareAndSet(old, ShuttingDown(Nil))) {
          reset {
            val i = tasks.reverseIterator
            while (i.hasNext) {
              i.next()()
            }
            takeMore()
          }
        } else {
          return takeMore()
        }
      }
      case Idle | ShuttedDown =>
        throw new IllegalStateException
    }
  }

  @annotation.tailrec
  final def shutDown() {
    get match {
      case old @ Idle => {
        if (!compareAndSet(old, ShuttedDown)) {
          return shutDown()
        }
      }
      case old @ Running(tasks) => {
        if (!compareAndSet(old, ShuttingDown(tasks))) {
          return shutDown()
        }
      }
      case ShuttingDown(_) | ShuttedDown =>
        throw new ShuttedDownException("SequentialRunner is shutted down!")
    }
  }

  @annotation.tailrec
  final def shutDown[U](task: => U @suspendable) {
    get match {
      case old @ Idle => {
        if (compareAndSet(old, ShuttingDown(Nil))) {
          reset {
            task
            takeMore()
          }
        } else {
          shutDown(task)
        }
      }
      case old @ Running(tasks) => {
        if (!compareAndSet(old, ShuttingDown(task _ :: tasks))) {
          return shutDown(task)
        }
      }
      case ShuttingDown(_) | ShuttedDown =>
        throw new ShuttedDownException("SequentialRunner is shutted down!")
    }
  }

  @annotation.tailrec
  final def post[U](task: => U @suspendable) {
    get match {
      case old @ Idle => {
        if (compareAndSet(old, Running(Nil))) {
          reset {
            task
            takeMore()
          }
        } else {
          post(task)
        }
      }
      case old @ Running(tasks) => {
        if (!compareAndSet(old, Running(task _ :: tasks))) {
          return post(task)
        }
      }
      case ShuttingDown(_) | ShuttedDown =>
        throw new ShuttedDownException("SequentialRunner is shutted down!")
    }
  }

  @inline
  final def send[U](task: => U @suspendable): U @util.continuations.suspendable = {
    util.continuations.shift { (continue: U => Unit) =>
      post {
        continue(task)
      }
    }
  }
}
