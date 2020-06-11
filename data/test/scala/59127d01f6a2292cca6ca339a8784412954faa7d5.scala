import java.beans.{PropertyChangeSupport => JavaPropertyChangeSupport}
import java.beans.{PropertyChangeListener, PropertyChangeEvent}

trait PropertyChangeSupport {
  private val javaPropertyChangeSupport = new JavaPropertyChangeSupport(this)

  def addPropertyChangeListener(listener:PropertyChangeListener) {
    javaPropertyChangeSupport.addPropertyChangeListener(listener)
  }

  def addPropertyChangeListener(propertyName: String, listener:PropertyChangeListener) {
    javaPropertyChangeSupport.addPropertyChangeListener(propertyName, listener)
  }

  def fireIndexedPropertyChange(propertyName: String, index:Int, oldValue:Any, newValue:Any) {
    javaPropertyChangeSupport.fireIndexedPropertyChange(propertyName, index, oldValue, newValue)
  }

  def firePropertyChange(propertyName: String, oldValue:Any, newValue:Any) {
    javaPropertyChangeSupport.firePropertyChange(propertyName, oldValue, newValue)
  }

  def getPropertyChangeListeners() = 
    javaPropertyChangeSupport.getPropertyChangeListeners()

  def getPropertyChangeListeners(propertyName: String) = 
    javaPropertyChangeSupport.getPropertyChangeListeners(propertyName)

  def hasListeners(propertyName: String) =
    javaPropertyChangeSupport.hasListeners(propertyName)

  def removePropertyChangeListener(listener:PropertyChangeListener) {
    javaPropertyChangeSupport.removePropertyChangeListener(listener)
  }

  def removePropertyChangeListener(propertyName: String, listener:PropertyChangeListener) {
    javaPropertyChangeSupport.removePropertyChangeListener(propertyName, listener)
  }
}


import java.awt.Point

class PropertyChangeSupportPoint(sx:Int = 0, sy:Int = 0) extends Point(sx, sy) with PropertyChangeSupport {
  
  def this(p:Point) {
    this(p.x, p.y)
  }

  override def move(x:Int, y:Int) {
    val oldX = this.x
    val oldY = this.y
    super.move(x, y)
    if (oldX != this.x)
      firePropertyChange("x", oldX, this.x)
    if (oldY != this.y)
      firePropertyChange("y", oldY, this.y)
  }

  override def setLocation(x:Double, y:Double) {
    val oldX = this.x
    val oldY = this.y
    super.setLocation(x, y)
    if (oldX != this.x)
      firePropertyChange("x", oldX, this.x)
    if (oldY != this.y)
      firePropertyChange("y", oldY, this.y)
  }

  override def setLocation(x:Int, y:Int) {
    super.setLocation(x, y)
  }

  override def translate(dx:Int, dy:Int) {
    val oldX = this.x
    val oldY = this.y
    super.translate(dx, dy)
    if (oldX != this.x)
      firePropertyChange("x", oldX, this.x)
    if (oldY != this.y)
      firePropertyChange("y", oldY, this.y)
  }
}

val p = new PropertyChangeSupportPoint(3, 5)
p.addPropertyChangeListener(new PropertyChangeListener {
  def propertyChange(evt:PropertyChangeEvent) {
    printf("%s: %s => %s\n",
      evt.getPropertyName,
      evt.getOldValue.toString,
      evt.getNewValue.toString)
  }
})
p.move(3, 3)
p.setLocation(2, 2)
p.setLocation(1.0, 2.0)
p.translate(3, 3)
