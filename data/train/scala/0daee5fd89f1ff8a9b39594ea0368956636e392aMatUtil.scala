package diyfea

import no.uib.cipr.matrix.DenseMatrix
import no.uib.cipr.matrix.UpperSymmPackMatrix
import no.uib.cipr.matrix.DenseVector

object MatUtil {
  def dump(m: DenseMatrix) {
    for (row <- 0 until m.numRows) {
      for (col <- 0 until m.numColumns) {
        print("%+2.4f" format m.get(row, col))
        if (col < (m.numColumns-1)) print(" ")
      }
      print("\n")
    }
  }
  
  def dump(m: UpperSymmPackMatrix) {
    for (row <- 0 until m.numRows) {
      for (col <- 0 until row) {
        print(" " * 8)
      }
      for (col <- row until m.numColumns) {
        print("%+2.4f" format m.get(row, col))
        if (col < (m.numColumns-1)) print(" ")
      }
      print("\n")
    }
  }
  
  def dump(v: DenseVector) {
    print("[")
    for (i <- 0 until v.size) {
      println("%f" format v.get(i))
      if (i < (v.size - 1)) print(" ")
    }
    print("]\n")
  }
}