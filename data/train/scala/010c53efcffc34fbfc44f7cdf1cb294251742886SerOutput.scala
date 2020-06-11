package cgta.serland

import cgta.serland.SerHints.Ser32Hints.Ser32Hint
import cgta.serland.SerHints.Ser64Hints.Ser64Hint

//////////////////////////////////////////////////////////////
// Copyright (c) 2010 Ben Jackman
// All Rights Reserved
// please contact ben@jackman.biz
// for licensing inquiries
// Created by bjackman @ 12/23/10 8:37 AM
//////////////////////////////////////////////////////////////


trait SerOutput {
  //When true the SerClasses should write themselves out in a Human Readable format
  def isHumanReadable: Boolean
  def writeStructBegin()
  def writeStructEnd()
  def writeFieldBegin(name: String, id: Int)
  def writeFieldEnd()
  def writeOneOfBegin(keyName: String, keyId: Int)
  def writeOneOfEnd()
  def writeIterable[A](xs: Iterable[A], sca: SerWritable[A])
  def writeOption[A](xs: Option[A], sca: SerWritable[A])

  /**
   * Note that for this method a toString version can be provided
   * this toString version will be used where human readability is
   * important, or the WriteFieldStart is called with the UseString SerHint
   *
   * The actual encoding scheme that backend chooses will depend on the SerHints
   */
  //Primitives
  def writeBoolean(b: Boolean)
  def writeChar(a: Char)
  def writeByte(b : Byte)
  def writeInt32(a: Int, hint: Ser32Hint)
  def writeInt64(a: Long, hint: Ser64Hint)
  def writeDouble(a: Double)
  def writeString(s: String)
  def writeByteArr(a: Array[Byte]): Unit = writeByteArrLen(a, 0, a.length)
  def writeByteArrLen(a: Array[Byte], offset: Int, length: Int): Unit
}




