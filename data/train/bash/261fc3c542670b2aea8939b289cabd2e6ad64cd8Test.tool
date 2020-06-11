
object Test {
  def main(): Unit = {
    println(new Tester().Test("haha", 10));
  }
}

class Tester {
  var i: Int;

  def Test(t: String, p: Int): String = {
    var ret: String;

    ret = t;
    i = p - 1;

    while(!(i <= this.getThreshold())) {
      ret = this.concat(ret, t);
      i = i - 1;
    }

    return ret;
  }

  def concat(s: String, i: Int): String = {
    return s + i;
  }

  def getThreshold(): Int = {
    return 0;
  }
}


{
    "main": {
        "code": [
            "const 10",
            "const \"haha\"",
            "new Tester",
            "invoke Test", 
            "println",
            "ret"
        ]
    },
    "classes": {
        "Tester": {
            "fields": {
                "i": "I"
            },
            "methods": {
                "concat": {
                    "args": [
                        {
                            "name": "s",
                            "type": "S"
                        },
                        {
                            "name": "i",
                            "type": "I"
                        }
                    ],
                    "vars": {
                        
                    },
                    "code": [
                        "lload s",
                        "lload i",
                        "add",
                        "ret"
                    ]
                },
                "getThreshold": {
                    "args": [
                        
                    ],
                    "vars": {
                        
                    },
                    "code": [
                        "const 0",
                        "ret"
                    ]
                },
                "Test": {
                    "args": [
                        {
                            "name": "t",
                            "type": "S"
                        },
                        {
                            "name": "p",
                            "type": "I"
                        }
                    ],
                    "vars": {
                        "ret": "S"
                    },
                    "code": [
                        "lload t",
                        "lstore ret",
                        "lload p",
                        "const 1",
                        "sub",
                        "fstore i",
                        "label loop",
                        "fload i",
                        "this",
                        "invoke getThreshold",
                        "le",
                        "not",
                        "jz loop_end",
                        "lload t",
                        "lload ret",
                        "this",
                        "invoke concat",
                        "lstore ret",
                        "fload i",
                        "const 1",
                        "sub",
                        "fstore i",
                        "goto loop",
                        "label loop_end",
                        "lload ret",
                        "ret"
                    ]
                }
            }
        }
    }
}