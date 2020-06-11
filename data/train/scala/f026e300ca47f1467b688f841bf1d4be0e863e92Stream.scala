package facades.node

import scala.concurrent.Future
import scala.scalajs.js

@js.native
trait Stream extends EventEmitter {
	def setEncoding(enc: String): this.type = js.native
	def close(): Unit = js.native
}

object Stream {
	@js.native
	trait Read extends Stream {
		def read(): String = js.native
		def pipe(to: Stream.Write): Unit = js.native
	}

	@js.native
	trait Write extends Stream {
		def write(buffer: Buffer): Unit = js.native
		def end(cb: Callback[Unit]): Unit = js.native
	}

	implicit class WriteOps (private val write: Write) extends AnyVal {
		def endWait(): Future[Unit] = async[Unit](write.end)
	}

	@js.native
	trait Duplex extends Read with Write {

	}

	@js.native
	trait Transform extends Duplex {

	}
}
