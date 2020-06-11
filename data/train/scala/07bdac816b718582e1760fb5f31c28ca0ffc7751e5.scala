package exercises.chapter10

import java.beans.{PropertyChangeEvent, PropertyChangeListener, PropertyChangeSupport}
import java.awt.Point

/**
 * Created by michal on 11/16/14.
 */
object e5 extends App {

  trait PropertyChangepcsLike {
    private val pcs = new PropertyChangeSupport(this);

    def addPropertyChangeListener(listener: PropertyChangeListener) {
      pcs.addPropertyChangeListener(listener)
    }

    def addPropertyChangeListener(propertyName: String, listener: PropertyChangeListener) {
      pcs.addPropertyChangeListener(propertyName, listener)
    }

    def	fireIndexedPropertyChange(propertyName: String, index: Int, oldValue: Boolean, newValue: Boolean) {
      pcs.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)
    }

    def fireIndexedPropertyChange(propertyName: String, index: Int, oldValue: Int, newValue: Int) {
      pcs.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)
    }

    def fireIndexedPropertyChange(propertyName: String, index: Int, oldValue: Object, newValue: Object) {
      pcs.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)
    }

    def firePropertyChange(evt: PropertyChangeEvent) {
      pcs.firePropertyChange(evt)
    }

    def	firePropertyChange(propertyName: String, oldValue: Boolean, newValue: Boolean) {
      pcs.firePropertyChange(propertyName, oldValue, newValue)
    }

    def	firePropertyChange(propertyName: String, oldValue: Int, newValue: Int) {
      pcs.firePropertyChange(propertyName, oldValue, newValue)
    }

    def	firePropertyChange(propertyName: String, oldValue: Object, newValue: Object) {
      pcs.firePropertyChange(propertyName, oldValue, newValue)
    }

    def removePropertyChangeListener(listener: PropertyChangeListener) =
      pcs.removePropertyChangeListener(listener)
  }

  class BeanPoint(x: Int, y: Int) extends Point(x, y) with PropertyChangepcsLike {
    override def move(x: Int, y: Int) = {
      val (oldX, oldY) = (this.x, this.y)
      super.move(x, y)
      fireIndexedPropertyChange("x", 0, oldX, x)
      fireIndexedPropertyChange("y", 1, oldY, y)
    }

    override def toString = f"BeanPoint($getX, $getY)"

  }

  implicit def function2PropertyChangeListener(f: PropertyChangeEvent => Unit) =
    new PropertyChangeListener {
      def propertyChange(event: PropertyChangeEvent) = f(event)
    }

  val point = new BeanPoint(1,1)
  println(point)

  point.addPropertyChangeListener(
    (event: PropertyChangeEvent) => println(s"Property changed event:$event")
  )

  point.move(3,3)
  println(point)


}
