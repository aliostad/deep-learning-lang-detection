package olim7t

import org.scalatest.{BeforeAndAfterEach, WordSpec}
import org.scalatest.matchers.MustMatchers

import ElevatorController._
import Protocol._

class ElevatorControllerSpec_SelfReset extends WordSpec
                                       with MustMatchers
                                       with BeforeAndAfterEach
                                       with ElevatorController {

  override def beforeEach {
    handle(Reset("from beforeEach"))
    dumpState must be === defaultState
  }

  "The elevator controller's self-reset mechanism" must {

    "increment the inactivity counter until the max count when it returns Nothing" in {
      (1 to MaxInactivity).foreach(i => {
        nextCommand must be === Nothing
        dumpState must be === defaultState.copy(inactiveSince = i)
      })
    }

    "reset the inactivity counter when it returns another command" in {
      (1 to MaxInactivity - 2).foreach(i => nextCommand)

      handle(Call(0, Up))
      nextCommand must be === Open
      dumpState.inactiveSince must be === 0
    }

    "always return Open once the max count is reached" in {
      val inactiveState: State = defaultState.copy(inactiveSince = MaxInactivity)

      (1 to MaxInactivity).foreach(i => nextCommand)
      dumpState must be === inactiveState

      nextCommand must be === Open
      dumpState must be === inactiveState

      nextCommand must be === Open
      dumpState must be === inactiveState
    }

    "reset to the default state when inactive and a Reset is received" in {
      (1 to MaxInactivity).foreach(i => nextCommand)

      handle(Reset("from test"))
      dumpState must be === defaultState
    }
  }
}
