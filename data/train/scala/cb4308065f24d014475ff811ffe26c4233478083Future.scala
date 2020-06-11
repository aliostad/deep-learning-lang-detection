package bluemold.concurrent

import org.bluemold.unsafe.Unsafe
import annotation.tailrec
import java.util.concurrent.CountDownLatch

object Future {
  val stateOffset = Unsafe.objectDeclaredFieldOffset( classOf[Future[Any]], "state" )
}
final class Future[T] {
  import Future._
  @volatile var state: State = State( None, failed = false, onComplete = Nil, onFailure = Nil )
  def isComplete = state.value ne None
  def isFailed = state.failed
  def getIfComplete = state.value
  @tailrec def onComplete( handler: (T)=>Unit ) {
    val old = state
    if ( old.value ne None ) handler( old.value.get )
    else if ( ! old.failed && ! Unsafe.compareAndSwapObject( this, stateOffset, old, State( None, false, handler :: old.onComplete, old.onFailure ) ) )
      onComplete( handler )
  }
  @tailrec def onFailure( handler: ()=>Unit ) {
    val old = state
    if ( old.failed ) handler()
    else if ( (old.value eq None) && ! Unsafe.compareAndSwapObject( this, stateOffset, old, State( None, false, old.onComplete, handler :: old.onFailure ) ) )
      onFailure( handler )
  }
  @tailrec def complete( value: T ) {
    val old = state
    if ( ! old.failed && (old.value eq None) ) {
      if ( Unsafe.compareAndSwapObject( this, stateOffset, old, State( Some( value ), false, old.onComplete, old.onFailure ) ) )
        old.onComplete foreach { h => h(value) }
      else complete( value )
    }
  }
  @tailrec def fail() {
    val old = state
    if ( ! old.failed && (old.value eq None) ) {
      if ( Unsafe.compareAndSwapObject( this, stateOffset, old, State( None, true, old.onComplete, old.onFailure ) ) )
        old.onFailure foreach { h => h() }
      else fail()
    }
  }
  /* Blocking method */
  @tailrec def get(): T = {
    val old = state
    if ( old.failed ) throw new NoSuchElementException( "Future failed" )
    else if ( old.value ne None ) old.value.get
    else {
      val latch = new CountDownLatch(1)
      if ( Unsafe.compareAndSwapObject( this, stateOffset, old, State( None, true, 
        { v: T => latch.countDown() } :: old.onComplete,
        { () => latch.countDown() } :: old.onFailure ) ) ) {
        latch.await()
        val result = state.value
        if ( result eq None ) throw new NoSuchElementException( "Future failed" )
        else result.get
      }
      else get()
    }
  }
  case class State( value: Option[T], failed: Boolean, onComplete: List[(T)=>Unit], onFailure: List[()=>Unit] )
} 