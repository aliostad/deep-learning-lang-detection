package ee.ui.members.details

import ee.ui.members.Event
import ee.ui.members.ReadOnlyEvent

trait ObservableVariable[T] extends ObservableValue[T] with Variable[T] {
  
  private val _change = Event[T]
  override val change: ReadOnlyEvent[T] = _change

  private val _valueChange = Event[(T, T)]
  override val valueChange: ReadOnlyEvent[(T, T)] = _valueChange
  
  override def setValue(value: T) = {
    val oldValue = this.value
    super.setValue(value)
    _change fire value
    _valueChange fire (oldValue, value)
  }
}