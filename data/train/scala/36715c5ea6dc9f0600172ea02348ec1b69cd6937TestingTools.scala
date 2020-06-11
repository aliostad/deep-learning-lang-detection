package ag.s3

import java.io.{File, FileOutputStream, OutputStreamWriter}

object TestingTools {

  // Create a sample text file
  def createSampleFile: File = {
    val file = File.createTempFile("temp", ".txt")
    file.deleteOnExit()
    val writer = new OutputStreamWriter(new FileOutputStream(file))
    writer.write("This is a test file.\n")
    writer.write("abcdefghijklmnopqrstuvwxyz\n")
    writer.write("01234567890112345678901234\n")
    writer.write("!@#$%^&*()-=[]{};':',.<>/?\n")
    writer.write("01234567890112345678901234\n")
    writer.write("abcdefghijklmnopqrstuvwxyz\n")
    writer.close()
    file
  }
}