package uvm.refimpl.mem

import uvm.refimpl.mem.TypeSizes.Word
import java.nio.ByteBuffer
import uvm.ssavariables.AtomicRMWOptr._
import jnr.ffi.{ Runtime, Memory, Pointer }
import uvm.refimpl.UvmRuntimeException
import uvm.refimpl.UvmIllegalMemoryAccessException
import uvm.refimpl.nat.NativeSupport

/**
 * Support for native memory access. Backed by JNR-FFI.
 */
class MemorySupport(val muMemorySize: Word) {
  val jnrRuntime = NativeSupport.jnrRuntime
  val theMemory = NativeSupport.theMemory

  val SIZE_LIMIT: Word = Int.MaxValue.toLong

  if (muMemorySize > SIZE_LIMIT) {
    throw new UvmRuntimeException(("Memory too large (%d bytes requested)." +
      " Due to the limitation of JNR-FFI, the maximum available memory size is %d bytes.").format(muMemorySize, SIZE_LIMIT))
  }

  val muMemory = Memory.allocateDirect(jnrRuntime, muMemorySize.toInt, true)
  val muMemoryBegin = muMemory.address()
  val muMemoryEnd = muMemoryBegin + muMemorySize

  def isInMuMemory(addr: Word): Boolean = muMemoryBegin <= addr && addr < muMemoryEnd

  def assertInMuMemory(inMu: Boolean, addr: Word): Unit = {
    if (inMu && !isInMuMemory(addr)) {
      throw new UvmIllegalMemoryAccessException("Accessed address 0x%x outside the Mu memory [0x%x-0x%x].".format(addr, muMemoryBegin, muMemoryEnd))
    }
  }

  def loadByte(addr: Word, inMu: Boolean = true): Byte = { assertInMuMemory(inMu, addr); theMemory.getByte(addr) }
  def loadShort(addr: Word, inMu: Boolean = true): Short = { assertInMuMemory(inMu, addr); theMemory.getShort(addr) }
  def loadInt(addr: Word, inMu: Boolean = true): Int = { assertInMuMemory(inMu, addr); theMemory.getInt(addr) }
  def loadLong(addr: Word, inMu: Boolean = true): Long = { assertInMuMemory(inMu, addr); theMemory.getLong(addr) }
  def loadI128(addr: Word, inMu: Boolean = true): (Long, Long) = { assertInMuMemory(inMu, addr); (theMemory.getLong(addr), theMemory.getLong(addr + 8)) }
  def loadFloat(addr: Word, inMu: Boolean = true): Float = { assertInMuMemory(inMu, addr); theMemory.getFloat(addr) }
  def loadDouble(addr: Word, inMu: Boolean = true): Double = { assertInMuMemory(inMu, addr); theMemory.getDouble(addr) }

  def storeByte(addr: Word, v: Byte, inMu: Boolean = true): Unit = { assertInMuMemory(inMu, addr); theMemory.putByte(addr, v) }
  def storeShort(addr: Word, v: Short, inMu: Boolean = true): Unit = { assertInMuMemory(inMu, addr); theMemory.putShort(addr, v) }
  def storeInt(addr: Word, v: Int, inMu: Boolean = true): Unit = { assertInMuMemory(inMu, addr); theMemory.putInt(addr, v) }
  def storeLong(addr: Word, v: Long, inMu: Boolean = true): Unit = { assertInMuMemory(inMu, addr); theMemory.putLong(addr, v) }
  def storeI128(addr: Word, v: (Long, Long), inMu: Boolean = true): Unit = { assertInMuMemory(inMu, addr); val (low, high) = v; theMemory.putLong(addr, low); theMemory.putLong(addr + 8, high) }
  def storeFloat(addr: Word, v: Float, inMu: Boolean = true): Unit = { assertInMuMemory(inMu, addr); theMemory.putFloat(addr, v) }
  def storeDouble(addr: Word, v: Double, inMu: Boolean = true): Unit = { assertInMuMemory(inMu, addr); theMemory.putDouble(addr, v) }

  def cmpXchgInt(addr: Word, expected: Int, desired: Int, inMu: Boolean = true): (Boolean, Int) = {
    assertInMuMemory(inMu, addr)
    val oldVal = loadInt(addr, inMu)
    if (oldVal == expected) {
      storeInt(addr, desired, inMu)
      return (true, oldVal)
    } else {
      return (false, oldVal)
    }
  }

  def cmpXchgLong(addr: Word, expected: Long, desired: Long, inMu: Boolean = true): (Boolean, Long) = {
    assertInMuMemory(inMu, addr)
    val oldVal = loadLong(addr, inMu)
    if (oldVal == expected) {
      storeLong(addr, desired, inMu)
      return (true, oldVal)
    } else {
      return (false, oldVal)
    }
  }

  def cmpXchgI128(addr: Word, expected: (Long, Long), desired: (Long, Long), inMu: Boolean = true): (Boolean, (Long, Long)) = {
    assertInMuMemory(inMu, addr)
    val oldVal = loadI128(addr, inMu)
    if (oldVal == expected) {
      storeI128(addr, desired, inMu)
      return (true, oldVal)
    } else {
      return (false, oldVal)
    }
  }

  def atomicRMWInt(optr: AtomicRMWOptr, addr: Word, opnd: Int, inMu: Boolean = true): Int = {
    assertInMuMemory(inMu, addr)
    val oldVal = loadInt(addr, inMu)
    val newVal = optr match {
      case XCHG => opnd
      case ADD  => oldVal + opnd
      case SUB  => oldVal - opnd
      case AND  => oldVal & opnd
      case NAND => ~(oldVal & opnd)
      case OR   => oldVal | opnd
      case XOR  => oldVal ^ opnd
      case MAX  => Math.max(oldVal, opnd)
      case MIN  => Math.min(oldVal, opnd)
      case UMAX => Math.max(oldVal - Int.MinValue, opnd - Int.MinValue) + Int.MinValue
      case UMIN => Math.min(oldVal - Int.MinValue, opnd - Int.MinValue) + Int.MinValue
    }
    storeInt(addr, newVal, inMu)
    return oldVal
  }

  def atomicRMWLong(optr: AtomicRMWOptr, addr: Word, opnd: Long, inMu: Boolean = true): Long = {
    assertInMuMemory(inMu, addr)
    val oldVal = loadLong(addr, inMu)
    val newVal = optr match {
      case XCHG => opnd
      case ADD  => oldVal + opnd
      case SUB  => oldVal - opnd
      case AND  => oldVal & opnd
      case NAND => ~(oldVal & opnd)
      case OR   => oldVal | opnd
      case XOR  => oldVal ^ opnd
      case MAX  => Math.max(oldVal, opnd)
      case MIN  => Math.min(oldVal, opnd)
      case UMAX => Math.max(oldVal - Long.MinValue, opnd - Long.MinValue) + Long.MinValue
      case UMIN => Math.min(oldVal - Long.MinValue, opnd - Long.MinValue) + Long.MinValue
    }
    storeLong(addr, newVal, inMu)
    return oldVal
  }

  def xchgI128(addr: Word, desired: (Long, Long), inMu: Boolean = true): (Long, Long) = {
    assertInMuMemory(inMu, addr)
    val oldVal = loadI128(addr, inMu)
    storeI128(addr, desired, inMu)
    return oldVal
  }

  def memset(addr: Word, size: Word, value: Byte): Unit = {
    theMemory.setMemory(addr, size, value)
  }

  def loadBytes(addr: Word, dest: Array[Byte], index: Int, len: Word, inMu: Boolean = true): Unit = {
    assertInMuMemory(inMu, addr)
    assertInMuMemory(inMu, addr + len - 1)
    assert(index >= 0, "Index is negative")
    assert(index + len <= dest.length, "array too small. dest.size=%d, len=%d".format(dest.size, len))
    theMemory.get(addr, dest, 0, len.toInt)
  }

  def storeBytes(addr: Word, dest: Array[Byte], index: Int, len: Word, inMu: Boolean = true): Unit = {
    assertInMuMemory(inMu, addr)
    assertInMuMemory(inMu, addr + len - 1)
    assert(index >= 0, "Index is negative")
    assert(index + len <= dest.length, "array too small. dest.size=%d, len=%d".format(dest.size, len))
    theMemory.put(addr, dest, 0, len.toInt)
  }
}
