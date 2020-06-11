/** NORMA.scala -> This file is the top level for NORMA in Chisel
Copyright (C) 2015 Stephen Tridgell

This file is part of a pipelined OLK application.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this code.  If not, see <http://www.gnu.org/licenses/>.
*/

package OLK

import Chisel._
import OLK.Dict._
import OLK.Kernel._
import OLK.Manage._
import OLK.NORMAStage._
import OLK.Sum._
import scala.collection.mutable.ArrayBuffer

/*
 This file implements the NORMA algorithm
 */

class IOBundle(val bitWidth : Int, val fracWidth : Int, val features : Int) extends Bundle {
  val forceNA = Bool(INPUT)

  val gamma   = Fixed(INPUT, bitWidth, fracWidth)
  val forget  = Fixed(INPUT, bitWidth, fracWidth)
  val eta     = Fixed(INPUT, bitWidth, fracWidth)
  val nu      = Fixed(INPUT, bitWidth, fracWidth)
  val example = Vec.fill(features){Fixed(INPUT, bitWidth, fracWidth)}

  val ft        = Fixed(OUTPUT, bitWidth, fracWidth)
  val addToDict = Bool(OUTPUT)
}

class IOBundle_C(bitWidth : Int, fracWidth : Int, features : Int) extends IOBundle(bitWidth, fracWidth, features) {
  val yC = Bool(INPUT)
}

class IOBundle_R(bitWidth : Int, fracWidth : Int, features : Int) extends IOBundle(bitWidth, fracWidth, features) {
  val yReg = Fixed(INPUT, bitWidth, fracWidth)
}

class NORMA(val bitWidth : Int, val fracWidth : Int, val stages : ArrayBuffer[Boolean], val log2Table : Int,
  val dictionarySize : Int, val features : Int, val appType : Int, clk : Option[Clock] = None,
  rst: Option[Bool] = None) extends Module( _clock = clk, _reset = rst ) {

  Predef.assert(fracWidth > log2Table, "Frac width too small or table too big")

  def log2Dict : Int = { log2Up(dictionarySize) }
  def log2Feat : Int = { log2Up(features) }
  def kStages : Int = { log2Feat + 7 }
  def sStages : Int = { stages.length - kStages - 1 }
  def pCycles : Int = { stages.count(_ == true) }
  def kCycles : Int = { stages.take(kStages).count(_ == true) }
  def sCycles : Int = { pCycles - kCycles - 1 }

  val ZERO = Fixed(0, bitWidth, fracWidth)
  var yReg = ZERO
  var yC   = Bool(true)
  val io = {
    if ( appType == 1 ) {
      val res = new IOBundle_C(bitWidth, fracWidth, features)
      yC = res.yC
      res
    } else if ( appType == 2 )
      new IOBundle(bitWidth, fracWidth, features)
    else {
      val res = new IOBundle_R(bitWidth, fracWidth, features)
      yReg = res.yReg
      res
    }
  }
  val dictModule   = Module(new Dict(bitWidth, fracWidth, dictionarySize, features, pCycles, true))
  val manageModule = Module(new Manage(bitWidth, fracWidth, pCycles - 1, true, appType))
  val manageModuleIO = manageModule.io.asInstanceOf[NORMAIOBundle]
  val kernelModule = Module(new Gaussian(bitWidth, fracWidth, dictionarySize, features, pCycles, stages.take(kStages), 1 << log2Table))
  val sumModule    = Module(new SumStage(bitWidth, fracWidth, stages.drop(kStages).take(sStages), dictionarySize, true))
  val normaModule  = Module(new NORMAStage(bitWidth, fracWidth, appType))
  val gammaReg     = Reg(init=ZERO, next = io.gamma) // Register to buffer gamma

  // Variable Connections
  if (appType == 1){
    val manageModuleIOc = manageModuleIO.asInstanceOf[NORMAcIOBundle]
    val normaModuleIOc  = normaModule.io.asInstanceOf[NORMAStage.IOBundle_C]
    manageModuleIOc.yCin := yC
    normaModuleIOc.yC    := manageModuleIOc.yCout
    //printf("yC: %d\n", manageModuleIOc.yCout)
  }
  if (appType == 3) {
    val manageModuleIOr = manageModuleIO.asInstanceOf[NORMArIOBundle]
    val normaModuleIOr  = normaModule.io.asInstanceOf[NORMAStage.IOBundle_R]
    manageModuleIOr.yRegin := yReg
    normaModuleIOr.yReg    := manageModuleIOr.yRegout
    //printf("yReg: %d\n", manageModuleIOr.yRegout)
  }

  // Dict Inputs
  dictModule.io.forget    := manageModuleIO.forgetout
  dictModule.io.forceNA   := normaModule.io.forceNAout
  dictModule.io.example   := io.example
  dictModule.io.alpha     := normaModule.io.alpha
  dictModule.io.addToDict := normaModule.io.addToDict

  // Manage Inputs
  manageModuleIO.eta      := io.eta
  manageModuleIO.nu       := io.nu
  manageModuleIO.forgetin := io.forget
  manageModuleIO.forceNAin := io.forceNA

  // Kernel Inputs
  kernelModule.io.pipeline   := dictModule.io.currentPipeline
  kernelModule.io.dictionary := dictModule.io.currentDict
  kernelModule.io.example    := io.example
  kernelModule.io.gamma      := gammaReg
  kernelModule.io.addToDict  := normaModule.io.addToDict

  // Sum Inputs
  sumModule.io.zi := kernelModule.io.pipelineOut
  sumModule.io.vi := kernelModule.io.dictOut
  sumModule.io.alphai := dictModule.io.currentAlpha
  sumModule.io.alpha  := normaModule.io.alpha
  sumModule.io.forget := manageModuleIO.forgetout
  sumModule.io.addToDict := normaModule.io.addToDict
  sumModule.io.forceNA := normaModule.io.forceNAout

  // Norma Stage Inputs
  normaModule.io.forceNA := manageModuleIO.forceNAout
  normaModule.io.sum     := sumModule.io.sum
  normaModule.io.zp      := sumModule.io.zp
  normaModule.io.wD      := sumModule.io.wD
  normaModule.io.forget  := manageModuleIO.forgetout
  normaModule.io.etapos  := manageModuleIO.etapos
  normaModule.io.etaneg  := manageModuleIO.etaneg
  normaModule.io.etanu   := manageModuleIO.etanu
  normaModule.io.etanu1  := manageModuleIO.etanu1

  // Outputs
  io.ft        := normaModule.io.ft
  io.addToDict := normaModule.io.addToDict

  // Debugging
  /*
  printf("addToDict: %d\n", normaModule.io.addToDict)
  printf("sum: %d\n", sumModule.io.sum)
  printf("zp: %d\n", sumModule.io.zp)
  printf("wD: %d\n", sumModule.io.wD)
  printf("forceNA: %d\n", manageModuleIO.forceNAout)
  printf("alpha: %d\n", normaModule.io.alpha)

  printf("currentPipeline\n")
  for (i <- 0 until pCycles ){
    printf("{")
    for (j <- 0 until features)
      printf("%d, ", dictModule.io.currentPipeline(i)(j))
    printf("}\n")
  }

  printf("currentDict\n")
  for (i <- 0 until dictionarySize ) {
    printf("%d {", dictModule.io.currentAlpha(i))
    for (j <- 0 until features)
      printf("%d, ", dictModule.io.currentDict(i)(j))
    printf("}\n")
  }
   */
}

