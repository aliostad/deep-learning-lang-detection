package op.stud.example

import op.stud.simulation.Wire
import op.stud.simulation.Simulator
import op.stud.simulation.ImplicitValue._
import op.stud.simulation.Wire._

object Lib1 {
  val triggerDelayDC = 2 
  val asynchResetDelay = 1
  
  def DC(d: Wire, nR: Wire, clock: Wire, q: Wire)(implicit simulator: Simulator) {
    import simulator._
    
    var oldClock = clock.getSignal
    def triggerAction() {
      val clockSig = clock.getSignal
      if (oldClock != Z && (!oldClock & clockSig).value) {    
        val dSig = d.getSignal
        afterDelay(triggerDelayDC) { 
          q.<==(dSig) 
        }
      }      
      oldClock = clockSig
    }

    def asynchResetAction() {
      simulator.afterDelay(asynchResetDelay) {
        if (nR.getSignal !=Z && !nR.getSignal.value) q.<==(false) 
      }
    }
    
    clock <= triggerAction
    nR <= asynchResetAction
  }
}