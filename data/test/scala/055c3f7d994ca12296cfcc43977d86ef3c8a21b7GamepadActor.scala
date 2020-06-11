package org.furidamu.SpaceMarauders

import org.lwjgl.input.Controllers;
import akka.actor._

case object ReadAxis
case object Poll
case object Start
case object Done

// X = Left/Right, Y = Up/Down
case class Axis(leftStickX: Float, leftStickY: Float,
  rightStickX: Float, rightStickY: Float, leftTrigger: Float, rightTrigger: Float)

case class AxisMoved(controller: Int, axis: Int, newValue: Float) extends InputEvent

object PadButton extends Enumeration {
  type PadButton = Value
  val A, B, X, Y, Back, Start, LeftBumper, RightBumper, PadLeft, PadRight, PadUp,
    PadDown, Guide, LeftStick, RightStick, LeftTrigger, RightTrigger, Unknown = Value
}

import PadButton.PadButton

abstract class ButtonEvent extends InputEvent
case class ButtonDown(controller: Int, btn: PadButton) extends ButtonEvent
case class ButtonUp(controller: Int, btn: PadButton) extends ButtonEvent

case class Rumble(controller: Int, strength: Float)


class GamepadActor extends Actor with ActorLogging {
  Controllers.create()
  Controllers.poll()
  Controllers.clearEvents()
  val controllers = (0 until Controllers.getControllerCount()).filter(
    c => Controllers.getController(c).getAxisCount() > 10)

  val inputActor = context.actorFor("/user/inputActor")
  var controllerAxes = (0 until Controllers.getControllerCount()).map(i =>
    i -> Axis(0, 0, 0, 0, -1, -1)).toMap

  var leftTriggerDown = false
  var rightTriggerDown = false

  def receive = {
    case Poll =>
      Controllers.poll()
      while(Controllers.next()) {
        val controller = Controllers.getEventSource()
        val controllerI = controller.getIndex()
        if(controllers.contains(controllerI)) {
          val componentI = Controllers.getEventControlIndex()
          if(Controllers.isEventButton()) {
            if(controller.isButtonPressed(componentI)) {
              inputActor ! ButtonDown(controllerI, translateButton(componentI))
            } else {
              inputActor ! ButtonUp(controllerI, translateButton(componentI))
            }
          } else {
            val newValue = controller.getAxisValue(componentI)
            if(componentI <= 4) {
              if(newValue == 1.0) {
                inputActor ! ButtonDown(controllerI, translateAxis(componentI))
              } else {
                inputActor ! ButtonUp(controllerI, translateAxis(componentI))
              }
            } else {
              val old = controllerAxes(controllerI)
              val (cutoffLow, cutoffHigh) = (-0.8, -0.7)
              val newAxis = componentI match {
                case 5 => Axis(newValue, old.leftStickY, old.rightStickX,
                  old.rightStickY, old.leftTrigger, old.rightTrigger)
                case 6 => Axis(old.leftStickX, newValue, old.rightStickX,
                  old.rightStickY, old.leftTrigger, old.rightTrigger)
                case 8 => Axis(old.leftStickX, old.leftStickY, newValue,
                  old.rightStickY, old.leftTrigger, old.rightTrigger)
                case 9 => Axis(old.leftStickX, old.leftStickY, old.rightStickX,
                  newValue, old.leftTrigger, old.rightTrigger)
                case 7 =>
                  if(!leftTriggerDown && newValue > cutoffHigh) {
                    inputActor ! ButtonDown(controllerI, PadButton.LeftTrigger)
                    leftTriggerDown = true
                  } else if(leftTriggerDown && newValue < cutoffLow) {
                    inputActor ! ButtonUp(controllerI, PadButton.LeftTrigger)
                    leftTriggerDown = false
                  }
                  Axis(old.leftStickX, old.leftStickY, old.rightStickX,
                       old.rightStickY, newValue, old.rightTrigger)
                case 10 =>
                  if(!rightTriggerDown && newValue > cutoffHigh) {
                    inputActor ! ButtonDown(controllerI, PadButton.RightTrigger)
                    rightTriggerDown = true
                  } else if(rightTriggerDown && newValue < cutoffLow) {
                    inputActor ! ButtonUp(controllerI, PadButton.RightTrigger)
                    rightTriggerDown = false
                  }
                  Axis(old.leftStickX, old.leftStickY, old.rightStickX,
                       old.rightStickY, old.leftTrigger, newValue)
              }
              controllerAxes = controllerAxes.updated(controllerI, newAxis)

              inputActor ! AxisMoved(controllerI, componentI, newValue)
            }
          }
        }
      }

    case Rumble(ctrl, strength) =>
      val controller = Controllers.getController(ctrl % 4)
      for(i <- 0 until controller.getRumblerCount()) {
        controller.setRumblerStrength(i, strength)
      }

    case ReadAxis =>
      sender ! controllerAxes
  }

  def translateAxis(axis: Int) = axis match {
    case 0 => PadButton.Start
    case 1 => PadButton.PadLeft
    case 2 => PadButton.PadRight
    case 3 => PadButton.PadUp
    case 4 => PadButton.PadDown
  }

  def translateButton(button: Int) = button match {
    case 0 => PadButton.A
    case 1 => PadButton.B
    case 2 => PadButton.X
    case 3 => PadButton.Y
    case 4 => PadButton.LeftBumper
    case 5 => PadButton.RightBumper
    case 6 => PadButton.Back
    case 7 => PadButton.Guide
    case 8 => PadButton.LeftStick
    case 9 => PadButton.RightStick
    case _ => PadButton.Unknown
  }
}
