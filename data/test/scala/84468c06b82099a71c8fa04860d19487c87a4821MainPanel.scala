package pl.edu.agh.volup.register.gui

import java.awt.BorderLayout
import java.awt.event.MouseEvent
import javax.swing.{JButton, JPanel}

import pl.edu.agh.volup.register.service.{ProcessService, UserService, ContentService}


class MainPanel(contentService: ContentService, contentRefresher: ContentRefresher) extends JPanel {
  setLayout(new BorderLayout())
  setBorder(Borders.empty())
  add(new CreateDescriptorPanel(contentService), BorderLayout.PAGE_START)
  add(new ManageProcessPanel(contentService, contentRefresher), BorderLayout.CENTER)
  add(new LogPanel, BorderLayout.PAGE_END)
}
