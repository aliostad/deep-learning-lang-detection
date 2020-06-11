package com.github.verlattice.client.screens

import com.github.verlattice.client.MockServer
import com.github.verlattice.client.UIBuilder._
import org.scalajs.dom.raw.{HTMLDivElement, HTMLParagraphElement}
import scala.concurrent.ExecutionContext.Implicits.global

import scala.concurrent.Future

class WelcomeScreen(div: HTMLDivElement) extends Screen {

  def visit(doneCallback: () => Unit): Unit = {

    div.appendChild(paragraph("<h1>Welcome</h1>"))
    div.appendChild(paragraph("Hello, and welcome to Verlattice."))
    div.appendChild(paragraph("Verlattice allows you to plan how you'll use the resources that are available to you."))
    div.appendChild(paragraph("If you're new to the application, please read the help."))

    val btn: HTMLParagraphElement = paragraph(button("Manage Resource Types", () => {
      changeToScreen(new ManageResourcesScreen(div), div)
    }))
    div.appendChild(btn)

    val btn2: HTMLParagraphElement = paragraph(button("Manage Actions", () => {
      changeToScreen(new ManageActionsScreen(div), div)
    }))
    div.appendChild(btn2)

    val managePlansButton: HTMLParagraphElement = paragraph(button("Manage Plans", () => {
      changeToScreen(new ManagePlansScreen(div), div)
    }))
    div.appendChild(managePlansButton)

    val btn3: HTMLParagraphElement = paragraph(button("View Help", () => {
      changeToScreen(new HelpScreen(div), div)
    }))

    div.appendChild(btn3)

    val versionParagraph = paragraph("[Retrieving version number]")
    div.appendChild(versionParagraph)

    val eventualVersion: Future[String] = MockServer.getVersion
    eventualVersion.onSuccess{
      case versionNumber: String =>
        versionParagraph.innerHTML = "<small>Verlattice - version " + versionNumber + "</small>"
    }
  }
}
