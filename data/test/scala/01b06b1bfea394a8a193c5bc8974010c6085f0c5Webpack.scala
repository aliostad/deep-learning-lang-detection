import play.sbt.PlayRunHook
import sbt._
import java.net.InetSocketAddress

object Webpack {
	def apply(base: File): PlayRunHook = {
		object WebpackProcess extends PlayRunHook {
			 
			 var process: Option[Process] = None
			 
			 override def beforeStarted() = {
			  println(base)
			 	Process("webpack.cmd  --progress --colors", base).run()
			 }
			 
			  override def afterStarted(addr: InetSocketAddress) = {
			  	process = Option(
				 	Process("webpack.cmd  --watch", base).run()
			  	)
			 }
			 
			 override def afterStopped() = {
			 	process.foreach(_.destroy())
			 	process = None
			 
			 }
			 
		}
		WebpackProcess
	
	}

}