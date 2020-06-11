package components

import scala.swing.Component
import javax.swing.JPanel
import java.awt.BorderLayout

/**
 * author mikwie
 *
 */
class FillPanel extends Component {

  override lazy val peer = new JPanel(new BorderLayout())

  def layoutManager = peer.getLayout.asInstanceOf[BorderLayout]

  def set(component: Component) = {
    val old = layoutManager.getLayoutComponent(BorderLayout.CENTER)
    if(old != null) {
      peer.remove(old)
    }
    peer.add(component.peer, BorderLayout.CENTER)
    repaint()
    revalidate()
  }
}
