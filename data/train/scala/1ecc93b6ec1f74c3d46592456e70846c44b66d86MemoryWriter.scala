package com.github.pawelkrol.CommTest

import com.github.pawelkrol.CPU6502.ByteVal

import MiscUtils._

trait MemoryWriter extends CPU6502Spec {

  protected def writeByteAt(address: Int, value: ByteVal) {
    writeByteAt(address.toShort, value)
  }

  protected def writeByteAt(address: Short, value: ByteVal) {
    memory.write(address, value)
  }

  protected def writeByteAt(name: String, value: ByteVal) {
    writeByteAt(label2address(name), value)
  }

  protected def writeBytesAt(address: Int, values: ByteVal*) {
    writeBytesAt(address.toShort, values: _*)
  }

  protected def writeBytesAt(address: Short, values: ByteVal*) {
    values.zipWithIndex.foreach({ case (value, index) => writeByteAt(address + index, value) })
  }

  protected def writeBytesAt(name: String, values: ByteVal*) {
    writeBytesAt(label2address(name), values: _*)
  }

  protected def writeWordAt(address: Int, value: Int) {
    writeWordAt(address, value.toShort)
  }

  protected def writeWordAt(address: Int, value: Short) {
    writeWordAt(address.toShort, value)
  }

  protected def writeWordAt(address: Short, value: Int) {
    writeWordAt(address, value.toShort)
  }

  protected def writeWordAt(address: Short, value: Short) {
    val (lo, hi) = word2nibbles(value)
    writeBytesAt(address, lo, hi)
  }

  protected def writeWordAt(name: String, value: Int) {
    writeWordAt(name, value.toShort)
  }

  protected def writeWordAt(name: String, value: Short) {
    writeWordAt(label2address(name), value)
  }
}
