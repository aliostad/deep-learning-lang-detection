/**
  * Created by Pierre on 05/04/2016.
  * */

import amqp.Functions
import com.rabbitmq.client.Channel

object Main extends App {

  val connection = Functions.connect("localhost")
  val channel : Channel = Functions.createChannel(connection)

  // Get messages from Authentication for login requests
  Functions.receive(channel, "users", "direct", "login")

  // Get messages to manage users
  Functions.receive(channel, "users", "direct", "create_user")
  Functions.receive(channel, "users", "direct", "update_user")
  Functions.receive(channel, "users", "direct", "delete_user")
  Functions.receive(channel, "users", "direct", "get_user")
  Functions.receive(channel, "users", "direct", "get_users")

  // Get messages using for monitoring features
  Functions.receive(channel, "users", "direct", "health_users")
  Functions.receive(channel, "users", "direct", "metrics_users")
}
