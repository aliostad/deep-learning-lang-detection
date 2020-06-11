import javafx.beans.property.ObjectPropertyBase
import javafx.scene.paint.Color
import scala.collection.mutable
import scala.util.Random


class Manager(var colour: Color, employeeIndependence: Double) {

  def receiveInstruction(color: Color) {
    val random: Random = new Random()
    val red: Int = random.nextInt(255) + 1
    val green: Int = random.nextInt(255) + 1
    val blue: Int = random.nextInt(255) + 1

    val randColor: Color = Color.rgb(red, green, blue)
    this.color = color.interpolate(randColor, employeeIndependence)
  }

  val children = mutable.MutableList[Manager]()
  var colorProperty =
    new ObjectPropertyBase[Color]() {
      def getBean: AnyRef = colour

      def getName: String = "color"
    }

  def color = colour

  def manageChildren() {
    children.foreach({
      _.receiveInstruction(color)
    })
  }

  def color_=(colorVal: Color) {
    this.colour = colorVal
    colorProperty.set(colorVal)
    manageChildren()
  }

  def addChild(child: Manager) {
    children += child
  }
}
