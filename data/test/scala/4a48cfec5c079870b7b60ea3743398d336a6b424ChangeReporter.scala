/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Heiko Blobner
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package de.windelknecht.stup.utils.coding.reactive

import de.windelknecht.stup.utils.coding.reactive.Notify.NotifyEvent

object ChangeReporter {
  trait ChangeEvent    extends NotifyEvent
  case object OnChange extends ChangeEvent

  // message classes
  trait ChangeMsg

  /**
   * Property has changed.
   */
  case class PropertyChange(name: String, oldValue: Any, newValue: Any) extends ChangeMsg
}

trait ChangeReporter {this: Notify=>
  import ChangeReporter._

  /**
   * This method checks if the property value has changed. And in that case an event will be fired.
   *
   * @param propName is the name of the property
   * @param oldValue is the old value
   * @param newValue is the new value
   * @tparam T is the value type
   * @return the new value
   */
  protected def checkForChanges[T](
    propName: String,
    oldValue: T,
    newValue: T
    ): T = {
    if(oldValue != newValue)
      reportPropertyChange(propName, oldValue, newValue)

    newValue
  }

  /**
   * A few report methods for easier change notifying.
   */
  protected def reportChange(msg: ChangeMsg) = fireNotify(OnChange, msg)

  /**
   * Report a property change.
   *
   * @param name is the property name
   * @param oldValue is the old value
   * @param newValue is the new value
   */
  protected def reportPropertyChange(
    name: String,
    oldValue: Any,
    newValue: Any
    ) = reportChange(PropertyChange(name = name, oldValue = oldValue, newValue = newValue))
}
