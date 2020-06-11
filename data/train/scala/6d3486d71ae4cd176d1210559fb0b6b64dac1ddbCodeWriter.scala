package vmtranslator

import java.io.PrintWriter
import java.io.File

class CodeWriter(_filename: String) {
  val writer = new PrintWriter(_filename)

  var currentVmName = "" // for static variables
  var cmpCnt = 0 // for arithmetic commands with comparison (i.e. jumping w/ label)
  var callCnt = 0 // for return-address used by function callings

  def setFileName(filename: String) = {
    val file = new File(filename)
    currentVmName = file.getName.replaceAll("\\.vm", "")
  }

  def writeArithmetic(command: String) = {
    val unaryFunctions = Seq("neg", "not")
    val boolFunctions = Seq("eq", "gt", "lt")

    writePushPop(C_POP, "constant", 13) // y

    if (unaryFunctions contains command) {
      writer.write("@13\n")

      command match {
        case "neg" => writer.write("D=-M\n")
        case "not" => writer.write("D=!M\n")
      }
    } else { // binary functions
      writePushPop(C_POP, "constant", 14) // x
      writer.write("@14\n")
      writer.write("D=M\n")
      writer.write("@13\n")

      if (boolFunctions contains command) {
        val cmp = command match {
          case "eq"  => "JEQ"
          case "gt"  => "JGT"
          case "lt"  => "JLT"
        }
        writer.write("D=D-M\n")
        writer.write(s"@T$cmpCnt\n")
        writer.write(s"D;$cmp\n")
        writer.write("D=0\n")
        writer.write(s"@PUSH$cmpCnt\n")
        writer.write("0;JMP\n")
        writer.write(s"(T$cmpCnt)\n")
        writer.write("D=-1\n")
        writer.write(s"(PUSH$cmpCnt)\n")
        cmpCnt += 1
      } else {
        command match {
          case "add" => writer.write("D=D+M\n")
          case "sub" => writer.write("D=D-M\n")
          case "and" => writer.write("D=D&M\n")
          case "or"  => writer.write("D=D|M\n")
        }
      }
    }

    writer.write("@0\nM=M+1\nA=M-1\nM=D\n")
  }

  def writePushPop(command: CommandType, segment: String, index: Int) = {

    val accessSeg_i = segment match {
      case "constant" => s"@$index\n"
      case "local"    => s"@$index\nD=A\n@1\nA=M+D\n"
      case "argument" => s"@$index\nD=A\n@2\nA=M+D\n"
      case "this"     => s"@$index\nD=A\n@3\nA=M+D\n"
      case "that"     => s"@$index\nD=A\n@4\nA=M+D\n"
      case "pointer"  => s"@$index\nD=A\n@3\nA=A+D\n"
      case "temp"     => s"@$index\nD=A\n@5\nA=A+D\n"
      case "static"   => s"@$currentVmName.$index\n"
    }

    // only support `constant` segment
    if (command == C_PUSH) {
      // write to SP and SP++
      writer.write(accessSeg_i)

      segment match {
        case "constant" => writer.write("D=A\n")
        case _          => writer.write("D=M\n")
      }

      writer.write("@0\n")
      writer.write("M=M+1\n")
      writer.write("A=M-1\n")
      writer.write("M=D\n")
    } else if (command == C_POP) {
      // SP-- and read value
      writer.write(accessSeg_i)
      writer.write("D=A\n")
      writer.write("@15\n") // keep dist address
      writer.write("M=D\n")
      writer.write("@0\n") // SP-- and get popped value
      writer.write("M=M-1\n")
      writer.write("A=M\n")
      writer.write("D=M\n")
      writer.write("@15\n")
      writer.write("A=M\n") // move to the dist address
      writer.write("M=D\n")
    }
  }

  def writeLabel(label: String) = {
    writer.write(s"($label)\n")
  }

  def writeGoto(label: String) = {
    writer.write(s"@$label\n")
    writer.write("0;JMP\n")
  }

  def writeIf(label: String) = {
    // pop and keep it in D
    writePushPop(C_POP, "constant", 13)
    writer.write("@13\n")
    writer.write("D=M\n")

    // if popped value != 0 -> jump to the label
    writer.write(s"@$label\n")
    writer.write("D;JNE\n")
  }

  def writeCall(functionName: String, numArgs: Int) = {
    // define return-address as a unique symbol
    // and push the address itself
    writer.write(s"@return-address.$callCnt\n")
    writer.write("D=A\n")
    writer.write("@0\n")
    writer.write("M=M+1\n")
    writer.write("A=M-1\n")
    writer.write("M=D\n")

    // push LCL address
    writer.write("@1\n")
    writer.write("D=M\n")
    writer.write("@0\n")
    writer.write("M=M+1\n")
    writer.write("A=M-1\n")
    writer.write("M=D\n")

    // push ARG address
    writer.write("@2\n")
    writer.write("D=M\n")
    writer.write("@0\n")
    writer.write("M=M+1\n")
    writer.write("A=M-1\n")
    writer.write("M=D\n")

    // push THIS address
    writer.write("@3\n")
    writer.write("D=M\n")
    writer.write("@0\n")
    writer.write("M=M+1\n")
    writer.write("A=M-1\n")
    writer.write("M=D\n")

    // push THAT address
    writer.write("@4\n")
    writer.write("D=M\n")
    writer.write("@0\n")
    writer.write("M=M+1\n")
    writer.write("A=M-1\n")
    writer.write("M=D\n")

    // ARG(M[2]) = SP(M[0]) - n - 5
    writer.write("@0\nD=M\n")
    writer.write(s"@$numArgs\nD=D-A\n")
    writer.write("@5\nD=D-A\n")
    writer.write("@2\nM=D\n")

    // LCL(M[1]) = SP(M[0])
    writer.write("@0\nD=M\n@1\nM=D\n")

    writeGoto(functionName)

    writeLabel(s"return-address.$callCnt")
    callCnt += 1
  }

  def writeReturn() = {
    // M[13] = LCL(M[1])
    writer.write("@1\nD=M\n@13\nM=D\n")

    // M[14] = M[ M[13] - 5 ]
    writer.write("@5\nD=A\n@13\nA=M-D\nD=M\n@14\nM=D\n")

    // write popped value to M[ ARG(M[2]) ]
    writePushPop(C_POP, "argument", 0)

    // SP(M[0]) = ARG(M[2]) + 1
    writer.write("@2\nD=M\n@0\nM=D+1\n")

    // THAT(M[4]) = M[ M[13] - 1 ]
    writer.write("@1\nD=A\n@13\nA=M-D\nD=M\n@4\nM=D\n")

    // THIS(M[3]) = M[ M[13] - 2 ]
    writer.write("@2\nD=A\n@13\nA=M-D\nD=M\n@3\nM=D\n")

    // ARG(M[2]) = M[ M[13] - 3 ]
    writer.write("@3\nD=A\n@13\nA=M-D\nD=M\n@2\nM=D\n")

    // LCL(M[1]) = M[ M[13] - 4 ]
    writer.write("@4\nD=A\n@13\nA=M-D\nD=M\n@1\nM=D\n")

    // goto the return address (M[14])
    writer.write("@14\nA=M\n0;JMP\n")
  }

  def writeFunction(functionName: String, numLocals: Int) = {
    writeLabel(functionName)

    // initialize k local variables with 0
    for (k <- 0 until numLocals) writePushPop(C_PUSH, "constant", 0)
  }

  def close() = writer.close()
}
