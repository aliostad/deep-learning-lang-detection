package com.idyria.osi.vui.lib.view




/**
 * Provides a method to Create a view process
 * 
 * When in a view process building, all created views and view processes will belong to it
 * 
 * 
 */
trait ViewProcessBuilder extends ViewBuilder {
  
  // Init
  //-------------
  var processStack = scala.collection.mutable.Stack[ViewProcess]()
  
  //-- If the Class mixing this trait is a ViewProcess, then add it already to the processStack
  this match {
    case vp : ViewProcess => processStack.push(vp)
    case _ =>
  }
 
  
  // View Add reaction
  //-------------------
  
  /**
   * Add to View lists of current process
   */
  this.onWith("view.created") {
    v : View =>
      
      processStack.headOption match {
        case Some(process) => 
          	
          	process.views+=v
          	v.process = process
          
        case None => 
      }
      
  }
  
  
  /**
   * Create A view process
   */
  def viewProcess(id : String)(cl: => Any) : ViewProcess =  {
    
    // Stack
    var process = new ViewProcess {}
    process.name = id
    processStack.push(process)
    
    // Execute
    cl
    
    // Destack
    processStack.pop
    
    return process
  }
}