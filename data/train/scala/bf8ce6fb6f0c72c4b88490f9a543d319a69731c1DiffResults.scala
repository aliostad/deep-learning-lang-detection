package OwenDiff

abstract class DiffResult(file1Index : Int, file2Index : Int,
  lengths : (Int, Int)) {
    def oldLineToString(line : String) : String = {
        "-"+line+"\n"
    }

    def newLineToString(line : String) : String = {
        "+"+line+"\n"
    }

    def equalLineToString(line : String) : String = {
        " "+line+"\n"
    }
}

case class Insert(file1Index : Int, file2Index : Int, lengths : (Int, Int),
  lines : Seq[String])
    extends DiffResult(file1Index, file2Index, lengths) {
    override def toString() = {
        lines.map(newLineToString).mkString("")
    }
}
case class Modify(file1Index : Int, file2Index : Int, lengths : (Int, Int),
  oldLines : Seq[String], newLines : Seq[String])
    extends DiffResult(file1Index, file2Index, lengths) {
    override def toString() = {
        oldLines.map(oldLineToString).mkString("") +
        newLines.map(newLineToString).mkString("")
    }
}
case class Delete(file1Index : Int, file2Index : Int, lengths : (Int, Int),
  oldLines : Seq[String])
    extends DiffResult(file1Index, file2Index, lengths) {
    override def toString() = {
        oldLines.map(oldLineToString).mkString("")
    }
}
case class Equal(file1Index : Int, file2Index : Int, lengths : (Int, Int),
  lines : Seq[String])
    extends DiffResult(file1Index, file2Index, lengths) {
    override def toString() = {
        lines.map(equalLineToString).mkString("")
    }
}
