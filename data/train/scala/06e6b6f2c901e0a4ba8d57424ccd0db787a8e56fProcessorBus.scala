package com.simplifide.generate.blocks.proc2

import com.simplifide.generate.blocks.basic.flop.ClockControl
import com.simplifide.generate.signal.{OpType, SignalTrait}


// TODO Make the clk implicit
/**
 * Class which contains the write and read signals for a standard uProcessor Interface
 *
 * @constructor
 * @parameter writeAddress Write AddressNew Line
 * @parameter writeValid   Valid line for writing data
 * @parameter writeData    Write Data Line for the Interface
 * @parameter readAddress  Read AddressNew Line
 * @parameter readValid    Valid line for writing data
 * @parameter readData     Read Data Line for the Interface
 *
 */

class ProcessorBus(val clk:ClockControl,
  val writeAddress:SignalTrait,
  val writeValid:SignalTrait,
  val writeData:SignalTrait,
  val readAddress:SignalTrait,
  val readValid:SignalTrait,
  val readData:SignalTrait) {

  val addressWidth  = writeAddress.fixed.width
  val dataWidth     = writeData.fixed.width

  def signals = List(clk.allSignals(OpType.Input),writeAddress,writeValid,writeData,readAddress,readValid,readData)


}

object ProcessorBus {
  def apply(clk:ClockControl,
            writeAddress:SignalTrait,
            writeValid:SignalTrait,
            writeData:SignalTrait,
            readAddress:SignalTrait,
            readValid:SignalTrait,
            readData:SignalTrait) = new ProcessorBus(clk,writeAddress,writeValid,writeData,readAddress,readValid,readData)
}