package biosimilarity.slmc.data.iterator {

import biosimilarity.slmc.data.Process

  
class RevealIterator(val process: Process, val alias: String) extends Iterator[Process] {
    
  var status =
    if(Process.testFn(process, alias)) {
      Finished
    } else if(Process.findRestrictedComponent(process, 0) == process.countComponents()) {
      Dummy(false)
    } else {
      NotFinished
    }
    
  var position =
    if(Process.testFn(process, alias)) {
      0
    } else {
      Process.findRestrictedComponent(process, 0)
    }
    
  var index = 0
  
  def maybeNext(): Option[Process] = {
    status match {
      case NotFinished =>
        val pos = position
        val ind = index
        info()
        Some(Process.revealComponents(pos, ind, alias)(process))
      case Dummy(b) =>
        status = Finished
        Some(process)
      case Finished =>
        None
    }
  }
  
  /** Auxiliary function to next_reveal */
  def info() {
    if (process.components(position).countRestrictions == (index + 1)) {
      val newPos = Process.findRestrictedComponent(process, position + 1)
      if (newPos == process.countComponents()) {
        status = Dummy(false)
      } else {
        position = newPos
        index = 0
      }
    } else {
      index = index + 1
    }
  }
  
  var buf: Option[Process] = maybeNext()
  
  def hasNext(): Boolean = {
    buf match {
      case Some(_) => true
      case None => false
    }
  }
  
  def next(): Process = {
    buf match {
      case Some(ref) => 
        buf = maybeNext()
        ref
      case None => throw new Exception("undefined call to RevealIterator.next()")
    }
  }
  
  
}
  
  
}