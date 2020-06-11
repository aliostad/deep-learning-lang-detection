package chapters.ch10

import java.awt.Point
import java.beans.{PropertyChangeEvent, PropertyChangeSupport, PropertyChangeListener}

/**
  * Chapter 10, Example 05:
  * The JavaBeans specification has the notion of a property change listener, a
  * standardized way for beans to communicate changes in their properties. The
  * PropertyChangeSupport class is provided as a convenience superclass for any bean
  * that wishes to support property change listeners. Unfortunately, a class that
  * already has another superclass -- such as JComponent -- must reimplement the
  * methods. Reimplement PropertyChangeSupport as a trait, and mix it into
  * the java.awt.Point class.
  */
object Ex05 extends App {

  trait PropertyChangeSupported {
    val pcs = new PropertyChangeSupport(this)
    def hasListeners(propertyName: String): Boolean = pcs.hasListeners(propertyName)
    def getPropertyChangeListeners: Array[PropertyChangeListener] = pcs.getPropertyChangeListeners
    def getPropertyChangeListeners(propertyName: String): Array[PropertyChangeListener] = pcs.getPropertyChangeListeners(propertyName)
    def removePropertyChangeListener(listener: PropertyChangeListener): Unit = pcs.removePropertyChangeListener(listener)
    def removePropertyChangeListener(propertyName: String, listener: PropertyChangeListener): Unit = pcs.removePropertyChangeListener(propertyName, listener)
    def firePropertyChange(propertyName: String, oldValue: scala.Any, newValue: scala.Any): Unit = pcs.firePropertyChange(propertyName, oldValue, newValue)
    def firePropertyChange(propertyName: String, oldValue: Int, newValue: Int): Unit = pcs.firePropertyChange(propertyName, oldValue, newValue)
    def firePropertyChange(propertyName: String, oldValue: Boolean, newValue: Boolean): Unit = pcs.firePropertyChange(propertyName, oldValue, newValue)
    def firePropertyChange(event: PropertyChangeEvent): Unit = pcs.firePropertyChange(event)
    def fireIndexedPropertyChange(propertyName: String, index: Int, oldValue: scala.Any, newValue: scala.Any): Unit = pcs.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)
    def fireIndexedPropertyChange(propertyName: String, index: Int, oldValue: Int, newValue: Int): Unit = pcs.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)
    def fireIndexedPropertyChange(propertyName: String, index: Int, oldValue: Boolean, newValue: Boolean): Unit = pcs.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)
    def addPropertyChangeListener(listener: PropertyChangeListener): Unit = pcs.addPropertyChangeListener(listener)
    def addPropertyChangeListener(propertyName: String, listener: PropertyChangeListener): Unit = pcs.addPropertyChangeListener(propertyName, listener)
  }

  class PointChangeSupport(xVal: Int = 0, yVal: Int = 0) extends Point(xVal, yVal) with PropertyChangeSupported {
    override def setLocation(x: Double, y: Double): Unit = {
      val oldX = getX
      val oldY = getY
      super.setLocation(x, y)
      pcs.firePropertyChange("x", oldX, getX)
      pcs.firePropertyChange("y", oldY, getY)
    }

    override def move(x: Int, y: Int): Unit = {
      val oldX = getX
      val oldY = getY
      super.move(x, y)
      pcs.firePropertyChange("x", oldX, getX)
      pcs.firePropertyChange("y", oldY, getY)
    }

    override def translate(dx: Int, dy: Int): Unit = {
      val oldX = getX
      val oldY = getY
      super.translate(dx, dy)
      pcs.firePropertyChange("x", oldX, getX)
      pcs.firePropertyChange("y", oldY, getY)
    }
  }

  val p = new PointChangeSupport(0,0)
  p.addPropertyChangeListener(new PropertyChangeListener {
    override def propertyChange(evt: PropertyChangeEvent): Unit = {
      println(s"${evt.getPropertyName} : ${evt.getOldValue} --> ${evt.getNewValue}")
    }
  })

  p.move(0,1)
  p.move(2,0)
  p.translate(4,4)
  p.setLocation(2.5, 3.3)
  p.setLocation(new Point(0,0))
}
