package ideajms.brokerwindow

import java.awt.BorderLayout._
import java.awt.{Dimension, BorderLayout, GridLayout}
import javax.swing._

import com.intellij.openapi.options.SettingsEditor
import com.intellij.ui.ScrollPaneFactory.createScrollPane
import com.intellij.util.ui.UIUtil.{SIDE_PANEL_BACKGROUND, setBackgroundRecursively}

class BrokerConfigEditor extends SettingsEditor[BrokerSourceSettings] {
  override def createEditor(): JComponent = new BrokerDetailsPanel().brokerDetailsPanel

  override def resetEditorFrom(s: BrokerSourceSettings): Unit = {}

  override def applyEditorTo(s: BrokerSourceSettings): Unit = {}
}

class BrokerDetailsPanel extends JPanel {

  def brokerDetailsPanel: JPanel = {
    val brokerDetailsPanel: JPanel = new JPanel()
    brokerDetailsPanel.setLayout(new BorderLayout())
    brokerDetailsPanel.add(brokerDetails)
    setBackgroundRecursively(brokerDetailsPanel, SIDE_PANEL_BACKGROUND)
    brokerDetailsPanel.setPreferredSize(new Dimension(300, 200))
    brokerDetailsPanel
  }

  def brokerDetails: JComponent = {
    val brokerDetails = new JPanel()
    createScrollPane(brokerDetails, true)
    brokerDetails.setLayout(new BorderLayout())
    brokerDetails.add(topPanel, NORTH)
    brokerDetails.add(bottomPanel, SOUTH)
    createScrollPane(brokerDetails, true)
  }

  def topPanel: JComponent = {
    val topPanel: JPanel = new JPanel()
    topPanel.setLayout(new GridLayout(5, 2))
    topPanel.add(new JLabel("Name: "))
    topPanel.add(new JTextField())
    topPanel.add(new JLabel("Broker url:"))
    topPanel.add(new JTextField())
    topPanel.add(new JLabel("Port:"))
    topPanel.add(new JTextField())
    topPanel.add(new JLabel("Username: "))
    topPanel.add(new JTextField())
    topPanel.add(new JLabel("Password: "))
    topPanel.add(new JTextField())
    topPanel
  }

  def bottomPanel: JComponent = {
    val bottomPanel: JPanel = new JPanel()
    val box: JComboBox[String] = new JComboBox[String]()
    box.addItem("Driver #1")
    box.addItem("Driver #2")
    bottomPanel.add(box)
    bottomPanel
  }

}
