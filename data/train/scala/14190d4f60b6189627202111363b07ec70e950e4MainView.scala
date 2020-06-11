package it.unibo.drescue.view

import javafx.stage.WindowEvent

import it.unibo.drescue.controller._

import scalafx.application.JFXApp.PrimaryStage
import scalafx.application.{JFXApp, Platform}
import scalafx.scene.Scene

/**
  * A class representing the main view of the civil protection application,
  * which is the container of all different grids
  *
  * @param loginGrid                the login grid, which is the first to be shown
  * @param loginController          the login controller
  * @param controller               the main controller
  * @param homeController           the home controller
  * @param enrollTeamControllerImpl the enroll team controller
  * @param manageRescuesController  the manage rescues controller
  */
class MainView(loginGrid: LoginGrid,
               loginController: LoginControllerImpl,
               controller: MainControllerImpl,
               homeController: HomeControllerImpl,
               enrollTeamControllerImpl: EnrollTeamControllerImpl,
               manageRescuesController: ManageRescuesControllerImpl) extends JFXApp {

  var login = new LoginGrid(loginController)
  var home = new HomeGrid(homeController)
  var team = new EnrollTeamGrid(enrollTeamControllerImpl)
  var manage = new ManageRescuesGrid(manageRescuesController, "Stop", controller.alertInManage)

  /**
    * Sets the type of stage to be shown with relative properties
    */
  def setStage(): Unit = {
    stage = new PrimaryStage {
      title = "D-rescue"
      resizable = false
      scene = new Scene {
        content = loginGrid.grid
      }
      onCloseRequest_=((event: WindowEvent) => {
        event.consume()
        Platform.exit()
        System.exit(0)
      })
    }
  }

  /**
    * Performs the views alternation
    *
    * @param view the next view to be shown
    */
  def changeView(view: String): Unit = {

    val LoginCase: String = "Login"
    val HomeCase: String = "Home"
    val EnrollCase: String = "NewTeam"
    val ManageRescuesCase: String = "ManageRescues"

    val newScene = new Scene {
      view match {
        case LoginCase =>
          login = new LoginGrid(loginController)
          content = login.grid
        case HomeCase =>
          home = new HomeGrid(homeController)
          content = home.grid
        case EnrollCase =>
          team = new EnrollTeamGrid(enrollTeamControllerImpl)
          content = team.grid
        case ManageRescuesCase =>
          val ActiveButton = controller.sendOrStop
          val alertInLabel = controller.alertInManage
          manage = new ManageRescuesGrid(manageRescuesController, ActiveButton, alertInLabel)
          content = manage.grid
        case _ =>
          val dialog = new CustomDialog(controller).createDialog(CustomDialog.Error)
          dialog.showAndWait()
      }
    }

    _stage.hide()
    _stage.scene_=(newScene)
    _stage.centerOnScreen()
    _stage.show()
  }

  /**
    * @return the main view stage
    */
  def _stage = stage
}
