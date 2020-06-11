package sequential_logic

import boolean_arithmetic._
import boolean_logic._

/**
  * Created by silve on 30/01/2017.
  */
case class PC(var ins: List[Boolean], var inc: Boolean, var load: Boolean, var reset: Boolean) {

  // Components
  private var register = Register(List.fill(ins.length)(false), false)
  private var falses = List.fill(ins.length)(false)
  private var q = List.fill(ins.length)(false) // output Q

  def out(clk: Boolean): List[Boolean] = {

    val insInc = Mux16(q, Incrementer(q).out, inc).out   // inc then out(t+1) = out(t) + 1
    val insLoad = Mux16(insInc, ins, load).out                                           // load then out(t+1) = in(t)
    val insFinal = Mux16(insLoad , falses, reset).out                                    // reset then out(t+1) = 0

    val loadOrReset = Or(load, reset).out
    val loadFinal = Or(loadOrReset, inc).out

    // Final result
    register.ins = insFinal
    register.load = loadFinal
    q = register.out(clk)
    register.out(clk)
  }
}

//    register.load = false
//    // inc then out(t+1) = out(t) + 1
//    val res1 = Mux16(register.out(clk), Incrementer(register.out(clk)).out, inc).out
//
//    // load then out(t+1) = in(t)
//    register.ins = ins
//    register.load = load
//    val res2 = Mux16(res1, register.out(clk), load).out
//
//    // reset then out(t+1) = 0
//    register.ins = List.fill(ins.length)(false)
//    val resFinal = Mux16(res2 , List.fill(ins.length)(false), reset).out
//
//    // Final result
//    resFinal
