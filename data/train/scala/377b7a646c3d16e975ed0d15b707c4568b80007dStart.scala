import scala.util.{Try, Success, Failure}
import scala.io.Source
import com.typesafe.scalalogging.slf4j.Logging
import org.elasticsearch.indices.InvalidAliasNameException
import org.json4s.jackson.JsonMethods
import org.json4s.JsonAST.JValue

object Start extends App with Logging {

  try {
    val action = args(0)
    val clusterName = args(1)
    val oldIndex = args(2)
    val newIndex = args(3)

    action.toLowerCase match {
      case "remap" => {
        val batchSize = Try(args(4).toInt.max(10)) getOrElse 500
        val writeTimeOut = Try(args(5).toInt.max(1000)) getOrElse 30000
        remap(clusterName, oldIndex, newIndex, batchSize, writeTimeOut)
      }
      case "update-alias" => {
        val alias = args(4)
        updateAlias(clusterName, oldIndex, newIndex, alias)
      }
      case _ => logger.info(s"$action is not a recognised action")
    }
  }
  catch {
    case e: ArrayIndexOutOfBoundsException => logger.info("An expected argument was missing. See the README for correct usage.")
  }

  def remap(clusterName: String, oldIndex: String, newIndex: String, batchSize: Int, writeTimeOut: Int): Unit = {
    val elasticsearch = new Elasticsearch(clusterName)
    if (!elasticsearch.indexExists(oldIndex)) {
      logger.error("Source index does not exist - migration failed")
    }

    if (!elasticsearch.indexExists(newIndex)) {
      logger.info(s"Creating index $newIndex...")
      elasticsearch.createIndex(newIndex)

      logger.info(s"Attempting to migrate data from $oldIndex to $newIndex")
      if (elasticsearch.migrate(oldIndex, newIndex, batchSize, writeTimeOut)) {
        logger.info("Migration complete! Check the results and update aliases as required")
      } else {
        logger.info("Failed (or nothing to do)")
      }
    } else {
      logger.error("Target index already exists - migration failed")
    }
    elasticsearch.closeConnection()
  }

  def updateAlias(clusterName: String, oldIndex: String, newIndex: String, alias: String): Unit = {
    logger.info(s"Attempting to update alias: $alias from $oldIndex")
    val elasticsearch = new Elasticsearch(clusterName)

    elasticsearch.moveAlias(oldIndex, newIndex, alias) match {
      case Success(_) => logger.info(s"Alias $alias has been moved from $oldIndex to $newIndex")
      case Failure(e) => e match {
        case _: IllegalArgumentException => logger.error(s"Index $oldIndex and/or $newIndex does not exist: cannot move the alias $alias")
        case _: InvalidAliasNameException => logger.error(s"Unable to update alias - check that $alias exists on $oldIndex")
        case _ => logger.error("Unable to update alias. Error is: " + e.getMessage)
      }
    }
  }

}
