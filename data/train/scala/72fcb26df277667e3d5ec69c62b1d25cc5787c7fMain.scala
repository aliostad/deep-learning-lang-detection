package it.unibo.drescue

import it.unibo.drescue.connection.{RabbitConnectionConstants, RabbitMQConnectionImpl, RabbitMQImpl}
import it.unibo.drescue.controller._
import it.unibo.drescue.localModel.CivilProtectionData
import it.unibo.drescue.view.{LoginGrid, MainView}

import scalafx.application.JFXApp

/**
  * The main object which starts the civil protection application
  */
object Main extends JFXApp {

  val connection = new RabbitMQConnectionImpl(RabbitConnectionConstants.REMOTE_HOST)
  connection.openConnection()
  var cpData = CivilProtectionData()
  var controller = new MainControllerImpl(cpData, new RabbitMQImpl(connection))
  var loginController = new LoginControllerImpl(controller, new RabbitMQImpl(connection))
  var homeController = new HomeControllerImpl(controller)
  var enrollTeamController = new EnrollTeamControllerImpl(controller, new RabbitMQImpl(connection))
  var manageRescuesController = new ManageRescuesControllerImpl(controller, new RabbitMQImpl(connection))
  var loginGrid = new LoginGrid(loginController)

  var view = new MainView(
    loginController = loginController,
    controller = controller,
    loginGrid = loginGrid,
    homeController = homeController,
    enrollTeamControllerImpl = enrollTeamController,
    manageRescuesController = manageRescuesController)

  controller.addView(view)
  view setStage()
  stage = view._stage
}
