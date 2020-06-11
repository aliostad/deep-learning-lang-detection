package org.mephi.cquiz.x86

import org.mephi.cquiz.{CAsAsmInput, Writer, Question, Topic}
import util.Random

object Decryption extends Topic {
  def id: String = "x86-decryption"

  def titleKey: String = "x86DecryptionTitle"

  def descriptionKey: String = "x86DecryptionDescription"

  def question(_seed: Long): Question = new CAsAsmInput {
    private val rng = new Random(_seed)
    private val data = rng.nextInt(0x10000)
    private val hexData = Integer.toHexString(data)
    private val key = rng.nextInt(0x10000)
    private val hexKey = Integer.toHexString(key)
    protected override val intelSyntax = rng.nextBoolean()
    private val codeSeed = rng.nextLong()

    protected override def functions = Set("main", "encrypt")

    protected override def sections = Set(".rodata")

    protected override def writeCode(code: Writer, answer: Option[String]) {
      rng.setSeed(codeSeed)

      code.write("#include <stdio.h>").nextLine()
      code.write("unsigned int encrypt(unsigned int data, unsigned int key)").block {
        code.write("unsigned int result = data;").nextLine()
        for (x <- rng.shuffle((1 to 4).toSeq)) {
          x match {
            case 1 => code.write("result ^= (key & 0xff);").nextLine()
            case 2 => code.write("result ^= (key & 0xff00);").nextLine()
            case 3 => code.write("result += ").write(rng.nextInt(0x100)).write(";").nextLine()
            case 4 => code.write("result -= ").write(rng.nextInt(0x100)).write(";").nextLine()
          }
        }
        code.write("return result;").nextLine()
      }.nextLine()
      code.write("int main()").block {
        code.write("unsigned int data, key;").nextLine()
        code.write("scanf(\"%x%x\", &data, &key);").nextLine()
        if (false) {
          code.write("fprintf(stderr, \"data=%x key=%x\\n\", data, key);").nextLine()
        }
        code.write("printf(\"%x\\n\", encrypt(data, key));").nextLine()
        code.write("/* key = ").write(hexKey).write(", output = ")
        answer match {
          case Some(x) => code.write(x)
          case None => code.write("???")
        }
        code.write(" */").nextLine()
      }
    }

    protected override def writeInput(input: Writer) {
      input.write(hexData + " " + hexKey)
    }

    protected override def writeAsmComments(code: Writer, result: Option[String]) {
      code.write("# Input:  x ").write(hexKey).nextLine()
      code.write("# Output: ").write(result match {
        case Some(x) => x
        case None => "???"
      }).nextLine()
      code.write("# Find:   x")
    }

    protected override def makeAnswer(input: String): String = {
      val array = input.split("\\s+")
      array(0)
    }
  }
}
