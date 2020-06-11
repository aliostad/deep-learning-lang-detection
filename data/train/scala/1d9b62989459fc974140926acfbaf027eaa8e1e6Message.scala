/**
 * @author Victor Caballero (vicaba)
 * @author Xavier Domingo (xadobu)
 */

package net.message

/**
 * A message.
 */
trait Message

/**
 * The content of a message
 */
trait MessageContent

/**
 * A message with a content
 * @param vectorClock the vector clock value.
 * @param content the content of the message
 */
sealed case class ContentMessage(vectorClock: Double, content: MessageContent) extends Message

/**
 * A control message.
 */
trait ControlMessage extends Message

/**
 * An ACK send by nodes to acknowledge transactions.
 */
trait ACK extends ControlMessage

/**
 *
 */
trait DiscoveryAndLookupMessage extends ControlMessage

/**
 *
 */
trait ManageConnection extends ControlMessage

/**
 * A new connection between nodes message.
 */
trait NewConnection extends ManageConnection {
  val id: Double
}