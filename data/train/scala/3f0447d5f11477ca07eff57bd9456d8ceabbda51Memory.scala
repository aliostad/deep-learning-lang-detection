package eu.shiftforward.Elements

import eu.shiftforward.{Bus, Wire}

trait Memory extends Sequential with ControlFlow {
  def register(in: Wire, load: Wire)(implicit clock: Wire) = {
    var state = false
    val out = new Wire

    def action() {
      val clockIn = clock.getSignal
      val loadIn = load.getSignal
      val inputA = in.getSignal
      schedule(ClockedGateDelay) {
        if (clockIn && loadIn) state = inputA
        if (clockIn) out <~ state
      }
    }

    clock addAction action

    out
  }

  def register(in: Bus, load: Wire)(implicit clock: Wire): Bus = in map { register(_, load) }

  def ram(data: Bus, address: Bus, load: Wire)(implicit clock: Wire): Bus =
    mux((demux(data, address), demux(load, address)).zipped map { register }, address)
}