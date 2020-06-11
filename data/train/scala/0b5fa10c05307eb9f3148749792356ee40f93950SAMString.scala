package cs.ucla.edu.bwaspark.datatype

class SAMString {
  var str: Array[Char] = new Array[Char](8192)
  var idx: Int = 0
  var size: Int = 8192

  def addCharArray(in: Array[Char]) {
    if((idx + in.size + 1) >= size) {
      size = size << 2
      val old = str
      str = new Array[Char](size)
      old.copyToArray(str, 0, idx + 1)
    }
 
    var i = 0
    while(i < in.size) {
      str(idx) = in(i)
      i += 1
      idx += 1
    }
  }
 
  def addChar(c: Char) {
    if((idx + 1) >= size) {
      size = size << 2
      val old = str
      str = new Array[Char](size)
      old.copyToArray(str, 0, idx + 1)
    }

    str(idx) = c
    idx += 1
  }
}

