import akka.actor._

case object StartProcessing
case class StartFinding(str : String)
case object ProcessingEnds
case class FoundData(str : String, hash : String, act : String)
case class NotFound(str : String)


class shaAlgo{	
	val zeroes : Int = 0
	
	def shaCalculator(s : String):String={
		val m = java.security.MessageDigest.getInstance("SHA-256").digest(s.getBytes("UTF-8"))
		val arr = m.map("%02x".format(_)).mkString
		var str = Integer.parseInt(arr.substring(0, zeroes), 16)
		if(str != 0)
			null
		else
			arr.mkString
	}
}

class First extends Actor{
	val obj = new shaAlgo()
	
	def receive = {
		case StartFinding(str) =>
			val localString = obj.shaCalculator(str)
			if (localString != null)
				sender ! FoundData(str, localString, "First")
			else
				sender ! NotFound("First")
			
		case ProcessingEnds =>
			context.stop(self)
		}
	}


class Second extends Actor{
	val obj = new shaAlgo()
	
	def receive = {
		case StartFinding(str) =>
			val localString = obj.shaCalculator(str)
			if (localString != null)
				sender ! FoundData(str, localString, "Second")
			else
				sender ! NotFound("Second")
			
		case ProcessingEnds =>
			context.stop(self)
	}
}

class Manage(first : ActorRef, second : ActorRef, system : ActorSystem) extends Actor{
	var c = '0'
	var len = 1
	var str = "AnupamBahl@"
	var oneBool = false
	var twoBool = false
	
	def nextString():String={
		c = (c+1).toChar
		if(c > 126){
			c = 'a'
			str = str + c
			len += 1
		}
		str + c
	}
	
	def receive = {
		case StartProcessing =>
			first ! StartFinding(nextString())
			second ! StartFinding(nextString())
		
		case FoundData(str, hash, act)=>
			println(str + "  ::::::  " + hash + "::::::" + act)
			if(act == "First"){
				first ! ProcessingEnds
				oneBool = true
			}
			else{
				second ! ProcessingEnds
				twoBool = true
			}
			if(oneBool & twoBool){
				context.stop(self)
				system.shutdown()
			}
		
		case NotFound("First") =>
			first ! StartFinding(nextString())
		case NotFound("Second") =>
			second ! StartFinding(nextString())
	}
}

object shaTest{
	def main(args : Array[String]){
		if(args.isEmpty)
			println("Enter arguments")
		val system = ActorSystem("SHA256System")
		val first = system.actorOf(Props[First], name = "First")
		val second = system.actorOf(Props[Second], name = "Second")
		val manage = system.actorOf(Props(new Manage(first, second, system)), name = "Manage")
		manage ! StartProcessing
	}
}