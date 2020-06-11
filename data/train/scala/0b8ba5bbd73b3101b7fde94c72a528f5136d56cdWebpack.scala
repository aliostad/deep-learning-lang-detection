import play.sbt.PlayRunHook
import sbt._
import java.net.InetSocketAddress

object Webpack {
	def apply(base: File): PlayRunHook = {

		object WebpackProcess extends PlayRunHook {
			var process: Option[Process] = None

			override def beforeStarted(): Unit = {
				Process("webpack --watch", base).run
			}

			override def afterStopped(): Unit = {
				process.map(p => p.destroy())
				process = None
			}
		}

	WebpackProcess
	}

	def dist(base: File) = {
		val process: ProcessBuilder = Process("webpack", base, "PROD_ENV" -> "true")
		println(s"Will run: ${process.toString} in ${base.getPath}")
		process.run().exitValue() match {
			case 0 => 0
			case code => throw new Exception(s"webpack failed with code=$code")
		}
	}
}
