/**
 * Copyright 2013 Andrew Conway. All rights reserved.
 */
package org.greatcactus.xs.frontend

/**
 * Manage undos/redos. This is basically done by storing the old root data structures.
 */


class UndoRedoManager[T](currentState:T) {
   var oldElements : List[(T,String)] = List((currentState,null)) // head of the list is what is currently displayed.
   var redoElements : List[(T,String)] = Nil
   var lastKey : Option[AnyRef] = None
   
   /**
    * When the user performs some edit, call this with the result of the edit and a description.
    * The key, if not null, is matched against the last key this is called with. If they are equal, then consider the last change to be part of this change.
    */
   def addUserChange(newElem:T,key:AnyRef,description:String) {
     lastKey match {
       case Some(k) if (k==key) =>
         oldElements=(newElem,description)::(oldElements.tail)
       case _ => 
         oldElements=(newElem,description)::oldElements
         lastKey = Option(key)
     }
     redoElements=Nil
   }
   /** If you can redo, return the description */
   def canRedo : Option[String] = redoElements match {
     case h::_ => Some(h._2)
     case _ => None
   }
   /** If you can undo, return the description */
   def canUndo : Option[String]= oldElements match {
     case wasCurrent::shouldNowBeCurrent::t => Some(wasCurrent._2)
     case _ => None
   }
   
   /** Perform an undo operation, and return the new value. None if can't undo. */
   def undo() : Option[T] = oldElements match {
     case wasCurrent::shouldNowBeCurrent::t => 
       redoElements = wasCurrent::redoElements
       oldElements = shouldNowBeCurrent::t
       lastKey=None
       Some(shouldNowBeCurrent._1)
     case _ => None
   }
   
   /** Perform a redo operation, and return the new value. None if can't undo. */
   def redo() : Option[T] = redoElements match {
     case newElement::t =>
       redoElements = t;
       oldElements = newElement::oldElements
       lastKey=None
       Some(newElement._1)
     case _ => None
   }
   
   def reset(base:T) {
     oldElements = List((currentState,null)) // head of the list is what is currently displayed.
     redoElements = Nil
     lastKey = None
   }
}