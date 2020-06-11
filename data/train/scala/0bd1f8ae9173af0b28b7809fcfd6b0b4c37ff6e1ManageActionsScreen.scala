package com.github.verlattice.client.screens

import com.github.verlattice.client.UIBuilder._
import com.github.verlattice.client.{Action, MockServer, UIBuilder}
import org.scalajs.dom.raw.{HTMLLabelElement, HTMLButtonElement, HTMLDivElement, HTMLInputElement}

class ManageActionsScreen(div: HTMLDivElement) extends Screen {

  def visit(doneCallback: () => Unit): Unit = {

    div.appendChild(paragraph("<h1>Manage Actions</h1>"))
    div.appendChild(paragraph("From here you can manage your actions."))

    div.appendChild(paragraph("<h2>Available Actions</h2>"))

    val newActionInput: HTMLInputElement = textInputBox("newActionName", "")
    val createButton: HTMLButtonElement = button("CREATE...", () => {
      MockServer.addAction(Action(newActionInput.value, List.empty, List.empty))
      resetToScreen(new EditActionScreen(div, newActionInput.value), div, () => {
        this.visit(doneCallback)
      })
    })

    div.appendChild(
      paragraph(
        newActionInput,
        createButton))

    newActionInput.focus()

    val actionNames: List[String] = MockServer.getActionNames

    if (actionNames.isEmpty) {
      div.appendChild(paragraph("<em>You haven't added any actions yet.</em>"))
    } else {
      div.appendChild(paragraph("The following actions are available:"))
      val listItems: List[HTMLDivElement] = actionNames.map(actionName =>
        UIBuilder.div(
          makeLabel(actionName),
          button("Edit...", () => {
            resetToScreen(new EditActionScreen(div, actionName), div, () => {
              this.visit(doneCallback)
            })
          }))
        )
      div.appendChild(list(listItems : _*)) // weird syntax

    }

    val homeButton: HTMLButtonElement = UIBuilder.button("Go Home", () => {
      changeToScreen(new WelcomeScreen(div), div)
    })
    div.appendChild(homeButton)

  }

  def makeLabel(actionName: String): HTMLLabelElement = {
    val lbl: HTMLLabelElement = label(actionName)
    lbl.setAttribute("style", "margin-right: 50px")
    lbl
  }
}
