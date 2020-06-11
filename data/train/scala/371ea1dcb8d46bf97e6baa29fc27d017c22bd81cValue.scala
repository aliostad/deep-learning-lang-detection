package com.chuangdie.jswing.model

import scala.swing.Publisher
import scala.swing.event.Event
import scala.reflect.ClassTag

/**
 * Created by lj on 2014/6/3.
 */
class Value(n: String, v: Any) extends Publisher{

  private var _value: Any = v

  def as[T] = _value.asInstanceOf[T]

  def name = n

  def value = _value

  def value_=(v: Any) = {
    val old = _value
    _value = v
    if (old != _value)
      publish(ValueChange( old, _value))
  }

  def setValue(v: Any) = {
    _value = v
  }

//  def getValueClass[T](implicit ct: ClassTag[T]): Class[_] = {
//    ct.runtimeClass
//  }

}

case class ValueChange(oldValue: Any, value: Any) extends Event
