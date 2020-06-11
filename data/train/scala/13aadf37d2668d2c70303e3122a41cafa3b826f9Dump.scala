package dcpu16.vm

/**
 * DCPU-16 bytecode pretty-printer.
 */
object Dump {
  /**
   * Pretty-print a section of bytecode: eight words by line, with each line
   * prefixed by its base address.
   *
   * @param bytecode An array of words.
   */
  def dumpWithAddress(bytecode: Array[Int]) {
    for (address <- 0 until bytecode.length) {
      print(if (0 == address % 8) "%04x:" format address else "")
      print(" %04x" format bytecode(address))
      print(if (7 == address % 8) "\n" else "")
    }
  }

  /**
   * Pretty-print a section of bytecode: eight words by line.
   *
   * @param bytecode An array of words.
   */
  def dumpWithoutAddress(bytecode: Array[Int]) {
    for (address <- 0 until bytecode.length) {
      print(" %04x" format bytecode(address))
      print(if (7 == address % 8) "\n" else "")
    }
  }
}
