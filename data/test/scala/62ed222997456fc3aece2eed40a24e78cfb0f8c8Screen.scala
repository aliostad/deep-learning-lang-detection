package hydrocul.kamehtmlconsole;

import java.io.PrintWriter;
import java.io.StringWriter;

trait Screen {

  def getRefreshJavaScriptCode(): String;

}

private[kamehtmlconsole] class ScreenImpl(console: Console) extends Screen {

  private var lines: Vector[LineInfo] = console.getLinesInfo;

  def getRefreshJavaScriptCode(): String = {
    val oldLines = lines;
    val newLines = console.getLinesInfo;
    lines = newLines;
    getRefreshJavaScriptCodeSub(oldLines, newLines);
  }

  private def getRefreshJavaScriptCodeSub(oldLines: Vector[LineInfo],
    newLines: Vector[LineInfo]): String = {

    import scala.annotation.tailrec;

    /**
     * Create javascript code. List of PrintWriter=>Unit を連続して呼び出すことで、
     * JavaScript code を生成できる。
     */
    @tailrec
    def sub(oldLines: Vector[LineInfo], newLines: Vector[LineInfo],
      deleteIndex: Int, prevLine: LineInfo, cont: Vector[PrintWriter=>Unit]):
      Vector[PrintWriter=>Unit] = {
      val (writer, oldLinesNext, newLinesNext, deleteIndexNext, prevLineNext) = if(oldLines.isEmpty){
        if(newLines.isEmpty){
          return cont;
        } else {
          val newFirst = newLines(0);
          if(prevLine==null){
            (((writer: PrintWriter) => LineInfo.printInsertFirst(writer, newFirst)),
              oldLines, newLines.drop(1), 0, newFirst);
          } else {
            (((writer: PrintWriter) => LineInfo.printInsertAfter(writer, prevLine, newFirst)),
              oldLines, newLines.drop(1), 0, newFirst);
          }
        }
      } else {
        val oldFirst = oldLines(0);
        if(deleteIndex > 0){
          (((writer: PrintWriter) => LineInfo.printDelete(writer, oldFirst)),
            oldLines.drop(1), newLines, deleteIndex - 1, prevLine);
        } else if(newLines.isEmpty){
          (((writer: PrintWriter) => LineInfo.printDelete(writer, oldFirst)),
            oldLines.drop(1), newLines, 0, prevLine);
        } else {
          val newFirst = newLines(0);
          if(oldFirst.lineId==newFirst.lineId){
            (((writer: PrintWriter) => LineInfo.printUpdate(writer, oldFirst, newFirst)),
              oldLines.drop(1), newLines.drop(1), 0, newFirst);
          } else {
            val i = oldLines.findIndexOf(_.lineId==newFirst.lineId);
            if(i >= 0){
              (((writer: PrintWriter) => LineInfo.printDelete(writer, oldFirst)),
                oldLines.drop(1), newLines, i - 1, prevLine);
            } else if(prevLine==null){
              (((writer: PrintWriter) => LineInfo.printInsertFirst(writer, newFirst)),
                oldLines, newLines.drop(1), 0, newFirst);
            } else {
              (((writer: PrintWriter) => LineInfo.printInsertAfter(writer, prevLine, newFirst)),
                oldLines, newLines.drop(1), 0, newFirst);
            }
          }
        }
      }
      sub(oldLinesNext, newLinesNext, deleteIndexNext, prevLineNext, cont :+ writer);
    }

    val sw = new StringWriter;
    val pw = new PrintWriter(sw);
    sub(oldLines, newLines, 0, null, Vector()).foreach(_(pw));
    sw.toString;

  }

}

