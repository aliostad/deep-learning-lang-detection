package cgta.serland
package backends

import java.io.ByteArrayOutputStream
import java.io.OutputStream

import cgta.serland.SerHints.Ser32Hints.Ser32Hint
import cgta.serland.SerHints.{Ser64Hints, Ser32Hints}
import cgta.serland.SerHints.Ser64Hints.Ser64Hint
import cgta.oscala.util.BinaryHelp
//////////////////////////////////////////////////////////////
// Copyright (c) 2011 Ben Jackman
// All Rights Reserved
// please contact ben@jackman.biz
// for licensing inquiries
// Created by bjackman @ 7/28/11 2:08 AM
//////////////////////////////////////////////////////////////


object SerPennyOut {
  object SerPennyState {
    val AboutToWriteMonad = 1
    val WritingMonad      = 2
    val WritingStruct     = 3
    val WritingOneOf      = 4
  }

  def toByteArray[A: SerClass](a: A): Array[Byte] = {
    val baos = new ByteArrayOutputStream()
    implicitly[SerClass[A]].write(a, new SerPennyOut(baos))
    baos.toByteArray()
  }
}


/**
 * The ultimate of speed and space.
 *
 */
class SerPennyOut(val os: OutputStream, override val isHumanReadable: Boolean = false) extends SerOutput {
  val SerPennyState = SerPennyOut.SerPennyState
  val OS            = BinaryHelp.ToOutputStream

  case class SPField(fid: Int, ignoredAnOption: Boolean = false)

  private var nextFidStack: List[Option[SPField]] = Nil
  private var stateStack  : List[Int]             = Nil

  override def writeStructBegin() = {
    writeEncodingType(SerPenny.WTs.WStruct)
    nextFidStack ::= None
    stateStack ::= SerPennyState.WritingStruct
  }
  override def writeStructEnd() = {
    writeStopField()
    nextFidStack = nextFidStack.tail
    stateStack = stateStack.tail
  }
  override def writeOneOfBegin(keyName: String, keyId: Int) = {
    if (keyId < 0) WRITE_ERROR(s"Cannot write a keyId less than 0 was [$keyId] for $keyName")
    writeEncodingType(SerPenny.WTs.WOneOf(keyId+1))
    stateStack ::= SerPennyState.WritingOneOf
  }
  override def writeOneOfEnd() = {
    stateStack = stateStack.tail
  }

  override def writeIterable[A](xs: Iterable[A], sca: SerWritable[A]) = {
    writeEncodingType(SerPenny.WTs.WList(xs.size))
    stateStack ::= SerPennyState.AboutToWriteMonad
    xs.foreach(x => sca.write(x, this))
    stateStack = stateStack.tail
  }

  override def writeOption[A](xs: Option[A], sca: SerWritable[A]) = {
    writeEncodingType(SerPenny.WTs.WOption(xs.size))
    stateStack ::= SerPennyState.AboutToWriteMonad
    xs.foreach(x => sca.write(x, this))
    stateStack = stateStack.tail
  }

  override def writeFieldBegin(name: String, id: Int) = {
    if (id < 0) WRITE_ERROR(s"Cannot write a fieldId less than 0 was [$id] for $name")
    nextFidStack ::= Some(SPField(id+1))
  }
  override def writeFieldEnd() = {
    nextFidStack = None :: nextFidStack.tail
  }
  override def writeBoolean(b: Boolean) {
    writeEncodingType(SerPenny.WTs.WSVarInt)
    OS.writeUVar(if (b) 1 else 0)(os)
  }
  override def writeByte(b: Byte) {
    writeEncodingType(SerPenny.WTs.WFixed8)
    OS.writeByte(b)(os)
  }
  override def writeChar(a: Char) = {
    writeEncodingType(SerPenny.WTs.WSVarInt)
    OS.writeUVar(a)(os)
  }
  override def writeInt32(a: Int, hint: Ser32Hint) = {
    writeEncodingType(SerPenny.WTs.WSVarInt)
    hint match {
      case Ser32Hints.SVarInt32 => OS.writeSVar(a)(os)
      case Ser32Hints.UVarInt32 => OS.writeUVar(a)(os)
    }
  }
  override def writeInt64(a: Long, hint: Ser64Hint) = {
    hint match {
      case Ser64Hints.SVarInt64 =>
        writeEncodingType(SerPenny.WTs.WSVarInt)
        OS.writeSVar(a)(os)
      case Ser64Hints.UVarInt64 =>
        writeEncodingType(SerPenny.WTs.WSVarInt)
        OS.writeUVar(a)(os)
      case Ser64Hints.Fixed64 =>
        writeEncodingType(SerPenny.WTs.WFixed64)
        OS.writeRawLittleEndian64(a)(os)
    }
  }
  override def writeDouble(a: Double) = {
    //DREAM EFFICIENT DOUBLE WRITING
//    writeEncodingType(SerPenny.WTs.WFixed64)
//    OS.writeDouble(a)(os)
    writeString(a.toString)
  }
  override def writeString(s: String) = {
    val bs = s.getBytesUTF8
    writeEncodingType(SerPenny.WTs.WByteArray(bs.length))
    OS.writeByteArray(bs, 0, bs.length)(os)
  }
  override def writeByteArrLen(a: Array[Byte], offset: Int, length: Int) = {
    writeEncodingType(SerPenny.WTs.WByteArray(length))
    OS.writeByteArray(a, offset, length)(os)
  }

  private def writeEncodingType(wireType: SerPenny.WTs.WT) {
    if (nextFidStack.nonEmpty && nextFidStack.head.isDefined) {
      val fd = nextFidStack.head.get
      if (wireType.isOption && !fd.ignoredAnOption) {
        //Ignore, unless we are more than a level into this
        nextFidStack = Some(nextFidStack.head.get.copy(ignoredAnOption = true)) :: nextFidStack.tail
      } else {
        writeFidType(fd.fid, wireType)
        nextFidStack = None :: nextFidStack.tail
      }

    } else {
      if (stateStack.isEmpty) {
        writeTypeInfoAndExtended(wireType)
      } else {
        //When we are writing out a list we only are going to write out the first part of the type info
        //Then we write out the extended before every portion
        if (stateStack.head == SerPennyState.AboutToWriteMonad) {
          writeOnlyTypeInfoNoExtended(wireType)
          stateStack = SerPennyState.WritingMonad :: stateStack.tail
        }

        if (stateStack.head == SerPennyState.WritingMonad) {
          writeNoTypeInfoOnlyExtended(wireType)
        } else {
          //Simple standard write here
          //Basically this is a one of type i am pretty certain
          writeTypeInfoAndExtended(wireType)
        }
      }
    }
  }

  private def writeExtendedTypeInfo(wt: SerPenny.WTs.WT) {
    wt match {
      case SerPenny.WTs.WOneOf(keyId) => OS.writeUVar(keyId)(os)
      case SerPenny.WTs.WByteArray(len) => OS.writeUVar(len)(os)
      case SerPenny.WTs.WList(len) => OS.writeUVar(len)(os)
      case SerPenny.WTs.WOption(len) => OS.writeUVar(len)(os)
      case _ =>
    }
  }

  private def writeOnlyTypeInfoNoExtended(wt: SerPenny.WTs.WT) {
    OS.writeUVar(wt.wtInt)(os)
  }

  private def writeNoTypeInfoOnlyExtended(wt: SerPenny.WTs.WT) {
    writeExtendedTypeInfo(wt)
  }

  private def writeTypeInfoAndExtended(wt: SerPenny.WTs.WT) {
    OS.writeUVar(wt.wtInt)(os)
    writeExtendedTypeInfo(wt)
  }


  private def writeFidType(fid: Int, wt: SerPenny.WTs.WT) {
    //Need to compose these together into a number
    val fidUVarInt = getFidWt(fid, wt)
    OS.writeUVar(fidUVarInt)(os)
    writeExtendedTypeInfo(wt)
  }

  private def writeStopField() {
    List
    OS.writeUVar(0)(os)
  }

  private def getFidWt(fid: Int, wt: SerPenny.WTs.WT): Long = {
    (fid.toLong << 3) | wt.wtInt
  }


}
