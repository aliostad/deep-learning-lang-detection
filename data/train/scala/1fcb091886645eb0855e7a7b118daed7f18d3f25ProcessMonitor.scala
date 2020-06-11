package se.nullable.punch

import akka.actor.{Actor, Props, Kill, OneForOneStrategy, SupervisorStrategy}
import SupervisorStrategy.Restart

import java.io.File


case object RestartProcess
class ProcessMonitor(processBuilder: ProcessBuilder) extends Actor {
	var process: Process = null  // Option[T] not applicable, since this being null once the actor has actually started should be treated as an error

	class RestartProcessException extends Exception

	override def supervisorStrategy = OneForOneStrategy() {
		case e: RestartProcessException => Restart
	}

	override def preStart() {
		process = processBuilder.start()

		// Launch a separate actor that kills the actor on process termination
		context.actorOf(Props(new Actor {
			def receive = {
				case process: Process =>
					process.waitFor()
					sender ! RestartProcess  // Restart on crash
			}
		}), name = "kill_monitor") ! process
	}

	// Kill the process on actor termination
	override def postStop() {
		process.destroy()
		process.waitFor()
	}

	def receive = {
		case RestartProcess =>
			throw new RestartProcessException
	}
}

object ProcessMonitor {
	def apply(defaultCmd: String, punchfile: File, dir: File, port: Int): ProcessMonitor = {
		val cmd =
			if (punchfile.exists)
				Seq("sh", punchfile.getAbsolutePath)
			else
				Seq("sh", "-c", defaultCmd)

		val pb = new ProcessBuilder(cmd: _*)
		pb.directory(dir)
		pb.environment().put("PORT", port.toString)
		pb.environment().put("DIR", dir.getAbsolutePath)
		pb.redirectOutput(ProcessBuilder.Redirect.INHERIT)
		pb.redirectError(ProcessBuilder.Redirect.INHERIT)
		new ProcessMonitor(pb)
	}
}