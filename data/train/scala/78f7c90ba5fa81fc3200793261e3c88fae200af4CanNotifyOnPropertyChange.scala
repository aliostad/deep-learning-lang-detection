package ch10.questions.q5

import java.awt.geom.Point2D
import java.beans.{PropertyChangeSupport, PropertyChangeListener}

trait CanNotifyOnPropertyChange {

  // Can't inherit from Point2D, as setLocationAndNotify won't compile
  self: Point2D =>

  val propertyManager: PropertyChangeSupport = new PropertyChangeSupport(this)

  // can't override setLocation(x: double, y: double) in Point2D class,
  // due to compatibility issues between java double & Scala Double
  def setLocationAndNotify(x: Double, y: Double) {
    val oldX = getX
    val oldY = getY
    self.setLocation(x, y)
    propertyManager.firePropertyChange("x", oldX, x)
    propertyManager.firePropertyChange("y", oldY, y)
  }

  def addPropertyChangeListener(listener: PropertyChangeListener) {
    propertyManager.addPropertyChangeListener(listener)
  }
}