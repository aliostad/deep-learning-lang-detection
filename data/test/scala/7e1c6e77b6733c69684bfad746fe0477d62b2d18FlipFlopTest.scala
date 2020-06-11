package com.joshcough.cpu.memory

;

import com.joshcough.cpu.electric._
import com.joshcough.cpu.memory._
import org.scalatest.FunSuite
import pimped.Equalizer._

trait FlipFlopTest extends FunSuite{

  test("flip flop") {

    val dataBit = Switch.on
    val writeBit = Switch.on

    val flipFlop = FlipFlop(dataBit, writeBit)

    //flipFlop.dump

    flipFlop.state mustBe On

    //println("------------------------")

    dataBit.turnOff

    //flipFlop.dump

    flipFlop.state mustBe Off

    //println("------------------------")

    writeBit.turnOff

    //flipFlop.dump

    flipFlop.state mustBe Off

    //println("------------------------")

    dataBit.turnOn

    //flipFlop.dump

    flipFlop.state mustBe Off

    //println("------------------------")

    writeBit.turnOn

    //flipFlop.dump

    flipFlop.state mustBe On
  }
}
