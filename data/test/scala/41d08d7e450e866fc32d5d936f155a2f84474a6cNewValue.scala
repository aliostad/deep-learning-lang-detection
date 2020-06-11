/**
 * Copyright (c) 2012-2013, Tomasz Kaczmarzyk.
 *
 * This file is part of BeanDiff.
 *
 * BeanDiff is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * BeanDiff is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BeanDiff; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
package org.beandiff.core.model.change

import org.beandiff.core.model.Property


object NewValue {
  def apply(prop: Property, oldVal: Any, newVal: Any) = new NewValue(prop, oldVal, newVal)
}

case class NewValue(
  property: Property,
  oldVal: Option[Any], 
  newVal: Option[Any]) extends Change with Equals {

  def this(property: Property, oldVal: Any, newVal: Any) = {
    this(property, Some(oldVal), Some(newVal))
  }
  
  override def perform(target: Any): Unit = {
    (oldVal, newVal) match {
      case (Some(oldVal), Some(newVal)) => property.setValue(target, newVal)
      case _ => {} // TODO is silent-ignore the best solution?
    }
  }
  
  override val targetProperty = property

  def canEqual(other: Any) = {
    other.isInstanceOf[NewValue]
  }
  
  override def equals(other: Any) = {
    other match {
      case that: NewValue => that.canEqual(NewValue.this) && oldVal == that.oldVal && newVal == that.newVal
      case _ => false
    }
  }
  
  override def oldValue = oldVal
  
  override def newValue = newVal
  
  override def hashCode() = {
    val prime = 41
    prime * (prime * (prime + oldVal.hashCode) + newVal.hashCode)
  }
  
  override def toString = "NewValue[" + property + "|" + oldVal + "->" + newVal + "]"

}