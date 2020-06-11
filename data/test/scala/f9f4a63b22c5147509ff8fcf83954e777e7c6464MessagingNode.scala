package networkframework.core.graph.messaging
import networkframework.core.graph.Node

/**
 * A node that can accept and process messages
 */
trait MessagingNode extends Node{
  
  /** What happens when you receive a packet */
  def receive(p: Packet)
  
  /** A standard process function */
  private var processFunc : (Packet => Unit) = (_ => Unit)
  
  /** Overloads the existing processing function */
  def setProcess(func : (Packet => Unit)) = processFunc = func
  
  /** When a packet reaches it's destination, process it */
  def process(p: Packet) = {
    processFunc(p)
  }
  
  /** Get the first package in the queue */
  def poll : Option[Packet]
}
