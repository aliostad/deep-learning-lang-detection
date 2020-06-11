package it.unibo.drescue.controller

import it.unibo.drescue.localModel.{AlertEntry, Observers}
import it.unibo.drescue.view.CustomDialog

import scalafx.collections.ObservableBuffer

/**
  * A class representing the home controller
  *
  * @param mainController the main controller
  */
class HomeControllerImpl(private var mainController: MainControllerImpl) extends Observer {

  mainController.model.addObserver(Observers.Home, this)

  var obsBuffer = new ObservableBuffer[AlertEntry]()

  /**
    * Performs actions relative to pressing on manage rescues button
    * and changes the view to manage rescues view
    */
  def manageRescuesPress() = {
    mainController.sendOrStop = "Stop"
    mainController.alertInManage = null
    mainController.changeView("ManageRescues")
  }

  /**
    * Performs actions relative to pressing on start rescue button
    * and changes the view to manage rescues view
    *
    * @param alert the selected alert for which the rescue will start
    */
  def startRescuePress(alert: AlertEntry) = {
    mainController.alertInManage = alert
    mainController.sendOrStop = "Send"
    mainController.changeView("ManageRescues")
  }

  /**
    * Starts a dialog that informs the user it's necessary to select an alert to start a rescue
    */
  def startSelectAlertDialog() = {
    val dialog = new CustomDialog(mainController).createDialog(CustomDialog.SelectAlert)
    dialog.showAndWait()
  }

  /**
    * Performs actions relative to pressing on enroll team button
    * and changes the view to enroll team view
    */
  def enrollTeamPress() = {
    mainController.initializeNotEnrolled()
    mainController.changeView("NewTeam")
  }

  override def onReceivingNotification(): Unit = {
    obsBuffer.clear()
    mainController.model.lastAlerts.forEach(
      (alertEntry: AlertEntry) => {
        obsBuffer add alertEntry
      }
    )
  }

}
