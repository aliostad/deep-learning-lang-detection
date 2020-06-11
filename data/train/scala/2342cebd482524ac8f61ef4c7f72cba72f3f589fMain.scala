import amqp.Functions
import com.rabbitmq.client.Channel

/**
  * Created by Pierre on 02/07/16.
  */

object Main extends App {

  override def main(args: Array[String]) {

    val connection = Functions.connect("localhost")
    val channel : Channel = Functions.createChannel(connection)

    // Get messages to manage projects
    Functions.receive(channel, "projects", "direct", "create_project")
    Functions.receive(channel, "projects", "direct", "update_project")
    Functions.receive(channel, "projects", "direct", "delete_project")
    Functions.receive(channel, "projects", "direct", "get_project")
    Functions.receive(channel, "projects", "direct", "get_projects")

    // Get messages using for monitoring features
    Functions.receive(channel, "projects", "direct", "health_projects")
    Functions.receive(channel, "projects", "direct", "metrics_projects")

  }
}