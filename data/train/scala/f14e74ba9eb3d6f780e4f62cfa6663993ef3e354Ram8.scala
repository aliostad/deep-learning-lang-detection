package sequential_logic

import boolean_logic._

/**
  * Created by silve on 29/01/2017.
  */

/**
  * Memory of 8 registers, each 16-bit wide.
  * The chip facilitates read and write operations, as follows:
  *     Read:  out(t) = RAM8[address(t)](t)
  *     Write: If load(t-1) then RAM8[address(t-1)](t) = in(t-1)
  * In words: the chip always outputs the value stored at the memory
  * location specified by address. If load == 1, the in value is loaded
  * into the memory location specified by address.  This value becomes
  * available through the out output starting from the next time step.
  */
case class Ram8(var ins: List[Boolean], var address: List[Boolean], var load: Boolean) {

  // Components
  private var registers = List.fill(8)(Register(List.fill(ins.length)(false), false))

  def out(clk: Boolean): List[Boolean] = {

    val loadA = DMux8Way(load, address).a
    val loadB = DMux8Way(load, address).b
    val loadC = DMux8Way(load, address).c
    val loadD = DMux8Way(load, address).d
    val loadE = DMux8Way(load, address).e
    val loadF = DMux8Way(load, address).f
    val loadG = DMux8Way(load, address).g
    val loadH = DMux8Way(load, address).h

    // Update registers
    registers.head.ins = ins
    registers.head.load = loadA

    registers(1).ins = ins
    registers(1).load = loadB

    registers(2).ins = ins
    registers(2).load = loadC

    registers(3).ins = ins
    registers(3).load = loadD

    registers(4).ins = ins
    registers(4).load = loadE

    registers(5).ins = ins
    registers(5).load = loadF

    registers(6).ins = ins
    registers(6).load = loadG

    registers(7).ins = ins
    registers(7).load = loadH

    val outRegA = registers.head.out(clk)
    val outRegB = registers(1).out(clk)
    val outRegC = registers(2).out(clk)
    val outRegD = registers(3).out(clk)
    val outRegE = registers(4).out(clk)
    val outRegF = registers(5).out(clk)
    val outRegG = registers(6).out(clk)
    val outRegH = registers(7).out(clk)

    Mux8Way16(outRegA, outRegB, outRegC, outRegD, outRegE, outRegF, outRegG, outRegH, address).out
  }

}
