package sequential_logic

import boolean_logic._

/**
  * Created by silve on 30/01/2017.
  */
case class Ram64(var ins: List[Boolean], var address: List[Boolean], var load: Boolean) {

  // Components
  private var ram8s = List.fill(8)(Ram8(List.fill(ins.length)(false), List.fill(address.length)(false), false))

  def out(clk: Boolean): List[Boolean] = {

    val selRam = address(0) :: address(1) :: address(2) :: Nil // MSB of address to select one of the RAM8
    val selReg = address(3) :: address(4) :: address(5) :: Nil // LSB of address to select one of the registers within the selected RAM8

    val loadA = DMux8Way(load, selRam).a
    val loadB = DMux8Way(load, selRam).b
    val loadC = DMux8Way(load, selRam).c
    val loadD = DMux8Way(load, selRam).d
    val loadE = DMux8Way(load, selRam).e
    val loadF = DMux8Way(load, selRam).f
    val loadG = DMux8Way(load, selRam).g
    val loadH = DMux8Way(load, selRam).h

    // Update rams 8
    ram8s.head.ins = ins
    ram8s.head.address = selReg
    ram8s.head.load = loadA

    ram8s(1).ins = ins
    ram8s(1).address = selReg
    ram8s(1).load = loadB

    ram8s(2).ins = ins
    ram8s(2).address = selReg
    ram8s(2).load = loadC

    ram8s(3).ins = ins
    ram8s(3).address = selReg
    ram8s(3).load = loadD

    ram8s(4).ins = ins
    ram8s(4).address = selReg
    ram8s(4).load = loadE

    ram8s(5).ins = ins
    ram8s(5).address = selReg
    ram8s(5).load = loadF

    ram8s(6).ins = ins
    ram8s(6).address = selReg
    ram8s(6).load = loadG

    ram8s(7).ins = ins
    ram8s(7).address = selReg
    ram8s(7).load = loadH

    val outRegA = ram8s.head.out(clk)
    val outRegB = ram8s(1).out(clk)
    val outRegC = ram8s(2).out(clk)
    val outRegD = ram8s(3).out(clk)
    val outRegE = ram8s(4).out(clk)
    val outRegF = ram8s(5).out(clk)
    val outRegG = ram8s(6).out(clk)
    val outRegH = ram8s(7).out(clk)

    Mux8Way16(outRegA, outRegB, outRegC, outRegD, outRegE, outRegF, outRegG, outRegH, selRam).out
  }
}
