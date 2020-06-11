package it.unibo.drescue.view

import javafx.scene.input.MouseEvent

import it.unibo.drescue.controller.ManageRescuesControllerImpl
import it.unibo.drescue.localModel.{AlertEntry, EnrolledTeamInfo}
import it.unibo.drescue.view.ViewConstants._

import scalafx.geometry.{Insets, Pos}
import scalafx.scene.control.TableColumn._
import scalafx.scene.control.{Button, Label, TableColumn, TableView}
import scalafx.scene.layout.{GridPane, HBox}
import scalafx.scene.text.Font

/**
  * A class representing the grid contained in the MainView
  * and relative to the manage rescues view
  *
  * @param manageRescuesController the manage rescues controller
  * @param activeButton            a string representing which button is active
  * @param alert                   the alert a new rescue will be started for
  */
class ManageRescuesGrid(private var manageRescuesController: ManageRescuesControllerImpl,
                        private var activeButton: String,
                        private var alert: AlertEntry) {

  val _grid = new GridPane() {

    hgap = Gap
    vgap = Gap5
    padding = Insets(Insets50)

    val DefaultFont = new Font(Font20)
    val TitleFont = new Font(Font30)
    val CheckBoxFont = new Font(Font18)
    val ButtonFont = new Font(Font25)

    val ManageRescuesLabel = new Label() {
      text = "MANAGE RESCUES:"
      font = TitleFont
      padding = Insets(Insets20)
    }
    val TitleBox = new HBox() {
      children = ManageRescuesLabel
      alignment = Pos.Center
    }
    add(TitleBox, ColumnRow0, ColumnRow0)
    GridPane.setConstraints(TitleBox, ColumnRow0, ColumnRow0, ColumnRow2, ColumnRow1)

    val AlertLabel = new Label() {
      if (alert != null) {
        val LabelText = "Alert: " + alert.timestamp.value +
          " " + alert.eventName.value +
          " lat: " + alert.latitude.value +
          " long: " + alert.longitude.value +
          " " + alert.districtID.value +
          " user: " + alert.userID.value +
          " upvotes: " + alert.upvotes.value
        text = LabelText
      }
      else {
        visible = false
      }
      font = DefaultFont
      padding = Insets(Insets10)
    }
    val AlertBox = new HBox() {
      children = AlertLabel
      alignment = Pos.Center
    }
    add(AlertBox, ColumnRow0, ColumnRow1)

    val ChooseTeamLabel = new Label() {
      text = "Choose team:"
      font = ButtonFont
      padding = Insets(Insets10)
    }
    val ChooseBox = new HBox() {
      children = ChooseTeamLabel
      alignment = Pos.Center
    }
    add(ChooseBox, ColumnRow0, ColumnRow3)

    var entries = manageRescuesController.obsBuffer

    val Table = new TableView[EnrolledTeamInfo](entries) {
      maxHeight = WidthHeight200
      columns ++= List(
        new TableColumn[EnrolledTeamInfo, String]() {
          text = "Team name"
          cellValueFactory = {
            _.value.teamName
          }
          prefWidth = WidthHeight300
        },
        new TableColumn[EnrolledTeamInfo, String]() {
          text = "Phone number"
          cellValueFactory = {
            _.value.phoneNumber
          }
          prefWidth = WidthHeight200
        },
        new TableColumn[EnrolledTeamInfo, String]() {
          text = "Availability"
          cellValueFactory = {
            _.value.availability
          }
          prefWidth = WidthHeight150
        },
        new TableColumn[EnrolledTeamInfo, String]() {
          text = "Cp ID"
          cellValueFactory = {
            _.value.cpID
          }
          prefWidth = WidthHeight150
        },
        new TableColumn[EnrolledTeamInfo, String]() {
          text = "Alert ID"
          cellValueFactory = {
            _.value.alertID
          }
          prefWidth = WidthHeight150
        }
      )
    }
    add(Table, ColumnRow0, ColumnRow4)

    val SendButton = new Button() {
      text = "Send"
      font = ButtonFont
      margin = Insets(Insets30)
      prefWidth = WidthHeight200
      onMouseClicked = (event: MouseEvent) => {
        val selected = Table.getSelectionModel.getFocusedIndex
        val team = entries.get(selected)
        manageRescuesController.sendPressed(team.teamID.value, alert.alertID.value)
      }
      if (activeButton == "Stop") {
        disable = true
      }

    }
    val StopButton = new Button() {
      text = "Stop"
      font = ButtonFont
      margin = Insets(Insets30)
      prefWidth = WidthHeight200
      onMouseClicked = (event: MouseEvent) => {
        val selected = Table.getSelectionModel.getFocusedIndex
        val team = entries.get(selected)
        manageRescuesController.stopPressed(team.teamID.value)
      }
      if (activeButton == "Send") {
        disable = true
      }

    }
    val BackButton = new Button() {
      text = "Back"
      font = ButtonFont
      margin = Insets(Insets30)
      prefWidth = WidthHeight200
      onMouseClicked = (event: MouseEvent) => {
        manageRescuesController.backPress()
      }
    }
    val ButtonBox = new HBox {
      alignment = Pos.Center
      padding = Insets(Insets10)
      children.addAll(SendButton, StopButton, BackButton)
    }
    add(ButtonBox, ColumnRow0, ColumnRow5)
  }

  /**
    * @return the manage rescues team grid
    */
  def grid = _grid
}
