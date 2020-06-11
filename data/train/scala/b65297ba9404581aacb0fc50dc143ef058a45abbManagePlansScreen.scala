package com.github.verlattice.client.screens

import com.github.verlattice.client.UIBuilder._
import com.github.verlattice.client.{Plan, Action, MockServer, UIBuilder}
import org.scalajs.dom.raw._

class ManagePlansScreen(div: HTMLDivElement) extends Screen {

  def visit(doneCallback: () => Unit): Unit = {

    div.appendChild(paragraph("<h1>Manage Plans</h1>"))
    div.appendChild(paragraph("From here you can manage your plans."))

    div.appendChild(paragraph("<h2>Available Plans</h2>"))

    val newPlanInput: HTMLInputElement = textInputBox("newPlanName", "")
    val createButton: HTMLButtonElement = button("CREATE", () => {
      val newPlanName: String = newPlanInput.value
      MockServer.addPlan(Plan(newPlanName, List.empty))
      resetToScreen(new EditPlanScreen(div, newPlanName), div, () => {
        this.visit(doneCallback)
      })
    })

    div.appendChild(
      paragraph(
        newPlanInput,
        createButton))

    newPlanInput.focus()

    val planNames: List[String] = MockServer.getPlanNames

    if (planNames.isEmpty) {
      div.appendChild(paragraph("<em>You haven't created any plans yet.</em>"))
    } else {
      div.appendChild(paragraph("Here are your plans:"))
      val listItems: List[HTMLDivElement] = planNames.map(planName =>
        UIBuilder.div(
          makeLabel(planName),
          if (MockServer.planHasIssues(planName)) makeLabel("[Plan has issues]") else makeLabel("[Plan is OK]"),
          button("Edit...", () => {
            resetToScreen(new EditPlanScreen(div, planName), div, () => {
              this.visit(doneCallback)
            })
          }))
      )
      div.appendChild(list(listItems : _*)) // weird syntax

    }

    val homeButton: HTMLParagraphElement = paragraph(UIBuilder.button("Go Home", () => {
      changeToScreen(new WelcomeScreen(div), div)
    }))
    div.appendChild(homeButton)

  }

  def makeLabel(actionName: String): HTMLLabelElement = {
    val lbl: HTMLLabelElement = label(actionName)
    lbl.setAttribute("style", "margin-right: 50px")
    lbl
  }
}
