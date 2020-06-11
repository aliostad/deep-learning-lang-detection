import java.net.InetSocketAddress

import play.sbt.PlayRunHook
import sbt._

object DynamoDB {
  def apply(): PlayRunHook = {

      object NpmProcess extends PlayRunHook {

        var watchProcess: Option[Process] = None

        override def beforeStarted(): Unit = {
					var process = "java -Djava.library.path=./dynamodb/DynamoDBLocal_lib -jar ./dynamodb/DynamoDBLocal.jar -dbPath dynamodb/database/"
					watchProcess = Some(Process(process).run)
        }

        override def afterStopped(): Unit = {
          watchProcess.map(p => p.destroy())
          watchProcess = None
        }
      }

      NpmProcess
    }
}
