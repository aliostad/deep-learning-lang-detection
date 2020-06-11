import jails._

object UnhandyCounter {
  def main(args: Array[String]) {
    
    val receiver: JoinPattern 		= new Receiver("count", "x")
    
    val triggeredProcess: Process = Add1 
    
    val sender:	Process						= new Sender("count", 1)
    
    val definition: Definition 		= ElementaryDefintion(receiver, triggeredProcess)
    
    val counter: Process 					= DefinitionInProcess(definition, sender)

    counter.start
  
  }
}

object Add1 extends MyProcess {
	def body {
		val input: Integer = rv("x").asInstanceOf[Integer]
   	val outputLink 		 = dv("count")
   	
   	println(input)
   	
   	Thread.sleep(1000)
   	outputLink ! input + 1  		
	}
}
  