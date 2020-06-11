package main

object examples {
  
  def example(n:Int) ={ n match {
    case 1 => {
      processor.process("p=3")
      processor.process("f=1x^1y^0+1x^0y^1")
      processor.process("g=1x^2y^1+4x^1y^2")
      processor.process("Draw log canonical region for e = 4")
      processor.process("p=5")
      processor.process("f=1x^1y^0+1x^0y^1")
      processor.process("g=1x^2y^1+4x^1y^2")
      processor.process("Draw log canonical region for e = 3")
      processor.process("p=7")
      processor.process("f=1x^1y^0+1x^0y^1")
      processor.process("g=1x^2y^1+4x^1y^2")
      processor.process("Draw log canonical region for e = 3")
      processor.process("p=11")
      processor.process("f=1x^1y^0+1x^0y^1")
      processor.process("g=1x^2y^1+4x^1y^2")
      processor.process("Draw log canonical region for e = 2")
    }
  }
    
  
  }
  
}