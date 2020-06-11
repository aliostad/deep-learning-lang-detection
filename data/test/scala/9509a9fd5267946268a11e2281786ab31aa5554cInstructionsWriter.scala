import com.nanni.nes.cpu.AddressingMode.AddressingMode
import com.nanni.nes.cpu.{AddressingMode, Cpu}

/**
  * Created by fcusumano on 5/10/17.
  */
class InstructionsWriter(cpu: Cpu) {
  private val ins = cpu.instructions
  private val mem = cpu.mem
  private var writeOffset = 0

  def seek(position: Int): Unit = {
    writeOffset = position
  }

  def writeInstruction(name: String, mode: AddressingMode): Unit =
    ins.getInstruction(name, mode) match {
    case Some(i) => writeByte(i.opcode)
    case _ => ()
  }

  def writeByte(value: Int): Unit = {
    mem.writeByte(writeOffset, value)
    writeOffset += 1
  }

  def writeWord(value: Int): Unit = {
    mem.writeWord(writeOffset, value)
    writeOffset += 2
  }

  def !(name: String, mode: AddressingMode = AddressingMode.Implied): Unit = writeInstruction(name, mode)
  def <<(value: Int): Unit = writeByte(value)
  def <<<(value: Int): Unit = writeWord(value)
}
