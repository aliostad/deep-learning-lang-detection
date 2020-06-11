package bluemold.concurrent

import scala.annotation.tailrec

final class CancelableHeapQueue[T <: Comparable[T]] {

  private final case class Node( e: Entry, left: Option[Node], right: Option[Node], weight: Int )
  
  final class Entry( val value: T ) {
    @volatile private[CancelableHeapQueue] var removed: Boolean = _ 
    def delete() { removed = true }
  }

  private val root = new AtomicReference[Option[Node]]()  

  private def pop( branch: Option[Node] ): Option[Node] = {
    branch match {
      case None => None
      case Some(node) =>
        node.left match {
          case None => node.right
          case Some(left) => node.right match {
            case None => node.left
            case Some(right) =>
              if ( left.e.value.compareTo( right.e.value ) < 0 )
                Some( Node( left.e, pop( node.left ), node.right, node.weight - 1 ) )
              else
                Some( Node( right.e, node.left, pop( node.right ), node.weight - 1 ) )
          }
        }
    }
  }

  private def push( branch: Option[Node], e: Entry ): Option[Node] = {
    branch match {
      case None => Some( Node( e, None, None, 1 ) )
      case Some(node) =>
        val (stays,goes) = if ( node.e.value.compareTo( e.value ) < 0 ) (node.e,e) else (e,node.e)
        val leftWeight = node.left map { _.weight } getOrElse { 0 }
        val rightWeight = node.right map { _.weight } getOrElse { 0 }
        if ( leftWeight < rightWeight )
          Some( Node( stays, push( node.left, goes ), node.right, node.weight + 1 ) )
        else
          Some( Node( stays, node.right, push( node.left, goes ), node.weight + 1 ) )
    }
  }



  @tailrec
  private def peek( branch: Option[Node] ): Option[T] = {
    branch match {
      case None => None
      case Some(node) =>
        if ( node.e.removed )
          node.left match {
            case None => peek( node.right )
            case Some(left) => node.right match {
              case None => peek( node.left )
              case Some(right) =>
                if ( left.e.value.compareTo( right.e.value ) < 0 )
                  peek( node.left )
                else
                  peek( node.right )
            }
          }
        else Some( node.e.value )
    }
  }

  def peek(): Option[T] = peek( root.get() )

  def pop(): Option[T] = {
    var oldRoot = root.get()
    var newRoot = pop( oldRoot )
    var node = oldRoot
    while ( node exists { _.e.removed } ) {
      node = newRoot
      newRoot = pop( newRoot )
    }
    while ( ( oldRoot ne None ) &&
        !root.compareAndSet( oldRoot, newRoot ) ) {
      oldRoot = root.get()
      newRoot = pop( oldRoot )
      node = oldRoot
      while ( node exists { _.e.removed } ) {
        node = newRoot
        newRoot = pop( newRoot )
      }
    }
    node map { _.e.value }
  }

  def popIfLessThanOrEqualTo( target: T ) = {
    var oldRoot = root.get()
    var newRoot = pop( oldRoot )
    var node = oldRoot
    while ( node exists { _.e.removed } ) {
      node = newRoot
      newRoot = pop( newRoot )
    }
    while ( ( oldRoot ne None ) &&
        ( node exists { _.e.value.compareTo(target) <= 0 } ) &&
        !root.compareAndSet( oldRoot, newRoot ) ) {
      oldRoot = root.get()
      newRoot = pop( oldRoot )
      node = oldRoot
      while ( node exists { _.e.removed } ) {
        node = newRoot
        newRoot = pop( newRoot )
      }
    }
    node filter { _.e.value.compareTo(target) <= 0 } map { _.e.value }
  }

  def push(value: T): Entry = {
    val entry = new Entry(value)
    var oldRoot = root.get()
    var newRoot = push( oldRoot, entry )
    while ( !root.compareAndSet( oldRoot, newRoot ) ) {
      oldRoot = root.get()
      newRoot = push( oldRoot, entry )
    }
    entry
  }
}
