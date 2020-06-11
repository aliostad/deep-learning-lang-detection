object ProcessMessage {
  def main(arg : Array[String]){

    process(1, 2)    // received tuple (1, 2)
   	process("Hello") // received hello
   	process("test")  // received a string test
   	process(2)      // received 2
   	process(12)      // received number 12
   	process(-32)     // received a negative number -32

    def process(message : Any) = {
   	  message match {
   	    case "Hello" => println("received hello")
   	    case x : String => println("received a string " + x)
   	    case (a, b) => println("received tuple (" + a + ", " + b + ")")
   	    case 2 => println("received 2")
   	    case x : Int if x < 0 => println("received a negative number " + x)
   	    case y : Int => println("received number " + y)
   	  }
 	  }
  }
}
