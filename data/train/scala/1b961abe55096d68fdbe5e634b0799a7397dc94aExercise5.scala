package chapter10

import java.beans.{PropertyChangeEvent, PropertyChangeListener, PropertyChangeSupport}

object Exercise5 extends App {

  trait PropertyChangeSupportLike {

    private val pcs = new PropertyChangeSupport(this)

    def getPropertyChangeListeners(propertyName: String) =
      pcs.getPropertyChangeListeners(propertyName)

    def removePropertyChangeListener(listener: PropertyChangeListener) {
      pcs.removePropertyChangeListener(listener)
    }

    def fireIndexedPropertyChange(propertyName: String,
                                  index: Int,
                                  oldValue: scala.Any,
                                  newValue: scala.Any) {
      pcs.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)
    }

    def hasListeners(propertyName: String) = pcs.hasListeners(propertyName)

    def firePropertyChange(event: PropertyChangeEvent) {
      pcs.firePropertyChange(event)
    }

    def firePropertyChange(propertyName: String,
                           oldValue: scala.Any,
                           newValue: scala.Any) {
      pcs.firePropertyChange(propertyName, oldValue, newValue)
    }

    def addPropertyChangeListener(listener: PropertyChangeListener) {
      pcs.addPropertyChangeListener(listener)
    }

    def firePropertyChange(propertyName: String, oldValue: Int, newValue: Int) {
      pcs.firePropertyChange(propertyName, oldValue, newValue)
    }

    def removePropertyChangeListener(propertyName: String,
                                     listener: PropertyChangeListener) {
      pcs.removePropertyChangeListener(propertyName, listener)
    }

    def addPropertyChangeListener(propertyName: String,
                                  listener: PropertyChangeListener) {
      pcs.addPropertyChangeListener(propertyName, listener)
    }

    def firePropertyChange(propertyName: String,
                           oldValue: Boolean,
                           newValue: Boolean) {
      pcs.firePropertyChange(propertyName, oldValue, newValue)
    }

    def fireIndexedPropertyChange(propertyName: String,
                                  index: Int,
                                  oldValue: Int,
                                  newValue: Int) {
      pcs.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)
    }

    def fireIndexedPropertyChange(propertyName: String,
                                  index: Int,
                                  oldValue: Boolean,
                                  newValue: Boolean) {
      pcs.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)
    }

    def getPropertyChangeListeners: Array[PropertyChangeListener] = pcs.getPropertyChangeListeners
  }

  class PointComponent(x: Int, y: Int)
    extends java.awt.Point(x, y) with PropertyChangeSupportLike {

    override def translate(dx: Int, dy: Int) {
      val oldX = getX
      val oldY = getY

      super.translate(dx, dy)

      firePropertyChange("x", oldX, getX)
      firePropertyChange("y", oldY, getY)
    }
  }

  val p = new PointComponent(10, 2)
  p.addPropertyChangeListener(new PropertyChangeListener {
    override def propertyChange(evt: PropertyChangeEvent) {
      println(
        s"${evt.getPropertyName} has been changed " +
          s"from ${evt.getOldValue} to ${evt.getNewValue}")
    }
  })

  p.translate(20, 10)
}
