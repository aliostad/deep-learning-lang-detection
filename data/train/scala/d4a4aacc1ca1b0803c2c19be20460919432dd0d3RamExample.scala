package com.joshcough.cpu.memory


import electric.Switch
import org.scalatest.FunSuite
import BitsToList._
import pimped.Equalizer._
import test.Timers


/**
 * @author dood
 * Date: Jun 6, 2009
 * Time: 10:59:49 PM
 */

class RamExample extends FunSuite with Timers{

  test("ram example") {
    val data = AllSwitchBitList(4) // each register 4 bits wide
    val address = AllSwitchBitList(3) // 8 addressable registers
    val writeBit = Switch.off // write bit off to start

    val ram = FastRAM(data, address, writeBit) //RAM!

    address.setTo(2)
    data.flip(0, 3)

    ram.dump
    ram.dataOut.toString mustBe "0000"

    writeBit.turnOn
    writeBit.turnOff

    ram.dump
    ram.dataOut.toString mustBe "1001"

    address.setTo(0)
    writeBit.turnOn
    data.flipAllBits
    writeBit.turnOff

    ram.dump
    ram.dataOut.toString mustBe "0110"

    address.setTo(2)
    ram.dump
    ram.dataOut.toString mustBe "1001"
  }
}