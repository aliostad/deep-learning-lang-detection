import java.awt.Point
import java.beans.{PropertyChangeListener, PropertyChangeEvent}

trait PropertyChangeSupport {
  val entity = new java.beans.PropertyChangeSupport

  def addPropertyChangeListener(listener: PropertyChangeListener): Unit = entity.addPropertyChangeListener(listener)

  def removePropertyChangeListener(listener: PropertyChangeListener): Unit = entity.removePropertyChangeListener(listener)

  def getPropertyChangeListeners: Array[PropertyChangeListener] = entity.getPropertyChangeListeners

  def addPropertyChangeListener(propertyName: String, listener: PropertyChangeListener): Unit = entity.addPropertyChangeListener(propertyName, listener)

  def removePropertyChangeListener(propertyName: String, listener: PropertyChangeListener): Unit = entity.removePropertyChangeListener(propertyName, listener)

  def getPropertyChangeListeners(propertyName: String): Array[PropertyChangeListener] = entity.getPropertyChangeListeners(propertyName)

  def firePropertyChange(propertyName: String, oldValue: scala.Any, newValue: scala.Any): Unit = entity.firePropertyChange(propertyName, oldValue, newValue)

  def firePropertyChange(propertyName: String, oldValue: Int, newValue: Int): Unit = entity.firePropertyChange(propertyName, oldValue, newValue)

  def firePropertyChange(propertyName: String, oldValue: Boolean, newValue: Boolean): Unit = entity.firePropertyChange(propertyName, oldValue, newValue)

  def firePropertyChange(event: PropertyChangeEvent): Unit = entity.firePropertyChange(event)

  def fireIndexedPropertyChange(propertyName: String, index: Int, oldValue: scala.Any, newValue: scala.Any): Unit = entity.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)

  def fireIndexedPropertyChange(propertyName: String, index: Int, oldValue: Int, newValue: Int): Unit = entity.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)

  def fireIndexedPropertyChange(propertyName: String, index: Int, oldValue: Boolean, newValue: Boolean): Unit = entity.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)

  def hasListeners(propertyName: String): Boolean = entity.hasListeners(propertyName)
}
val p = new Point with PropertyChangeSupport
p.addPropertyChangeListener(new PropertyChangeListener {
  override def propertyChange(evt: PropertyChangeEvent): Unit = println(evt.getPropertyName + " " +evt.getOldValue)
})
p.firePropertyChange("x", 0, 1)