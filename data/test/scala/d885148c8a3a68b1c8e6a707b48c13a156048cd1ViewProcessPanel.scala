package com.idyria.osi.vui.lib.view.components

import com.idyria.osi.vui.lib.view.ViewProcess
import com.idyria.osi.vui.lib.gridbuilder.GridBuilder
import com.idyria.osi.vui.core.stdlib.node.SGCustomNode
import com.idyria.osi.vui.lib.view.View
import com.idyria.osi.vui.core.components.scenegraph.SGNode
import com.idyria.osi.vui.lib.view.ViewProcessBuilder

/**
 * The View Process Panel is a SGNode component that manages the graphical connection to
 * a running view process
 */
class ViewProcessPanel extends SGCustomNode with GridBuilder with ViewProcessBuilder {

  // View Process Connection
  //----------

  var _viewProcess: ViewProcess = null

  //-- Default Process
  this.viewProcess = new ViewProcess {}

  /**
   * Set New View process
   * Record listeners to make GUI changes based on its progression
   */
  def viewProcess_=(vp: ViewProcess): Unit = {

    this._viewProcess = vp
    this.processStack.push(_viewProcess)

    this._viewProcess.onWith("view.progressTo") {
      v: View ⇒
        onUIThread {
          // Update View Panels container
          viewsPanel.clear
          viewsPanel <= v.render
          viewsPanel.revalidate
        }
        logFine("----> Switching view on: " + viewsPanel.base)

    }
    logFine("----> Listening on: " + vp.hashCode())

  }

  def viewProcess: ViewProcess = this._viewProcess

  // Views building in case of class extension
  //-------------

  // View Change
  //-----------------

  //-- Base GUI
  val viewsPanel = group
  viewsPanel.layout = stack

  //-- On Base GUI child add, make the component grow
  viewsPanel.onWith("child.added") {
    n: SGNode[_] => n(expand, alignCenter)
  }

  /**
   * UI -> Add a Group Grid
   */
  def createUI = {

    this.viewProcess match {
      case null ⇒
      case vp   ⇒ vp.resetProgress
    }

    viewsPanel
  }

}

/**
 * Factory to allow convenient definition of a view process inside a ViewProcessPanel:
 *
 * Example: (Enclosing class must mix trait ViewProcessBuilder)
 *
 * node <= ViewProcessPanel {
 *
 *  	viewProcess("name") {
 *
 *     	view("name") {
 *
 * 			...
 *
 *     	}
 *
 *   	}
 * }
 */
object ViewProcessPanel {
  def apply: ViewProcessPanel = new ViewProcessPanel

  def apply(vp: ViewProcess) = {

    var vPanel = new ViewProcessPanel
    vPanel.viewProcess = vp
    vPanel
  }

}

trait ViewProcessPanelBuilder extends ViewProcessBuilder {

  def viewProcessPanel(cl: => Any): ViewProcessPanel = {

    var panel = new ViewProcessPanel

    //-- Put panel Process on stack
    this.processStack.push(panel.viewProcess)

    //-- Execute closure
    cl

    this.processStack.pop

    panel

  }

}