/*
 * Copyright (c) 2008, Michael Pradel
 * All rights reserved. See LICENSE for details.
 */

package scala.roles.dp;

import scala.roles.TransientCollaboration

trait Composite[Core <: AnyRef] extends TransientCollaboration {
  
  object parent extends RoleMapper[Core, Parent] {
    def createRole = new Parent{}
  }
  
  object child extends RoleMapper[Core, Child] {
    def createRole = new Child{}
  }
  
  trait Parent extends Role[Core] {
    protected var children = List[Child]()
    
    def addChild(newChild: Child#Proxy) = {
      if (newChild.parentR != null) throw new Exception("Before adding this child, remove it from old parent: " + newChild.parentR)
      
      newChild.parentR = role
      children :+ child.roleOf(newChild.core)
    }
    
    def getChild(i: Int): Child#Proxy = 
      child.proxy(children(i))
    
    def removeChild(oldChild: Child#Proxy) = {
      // remove parent role if oldChild is the only child
      if (oldChild.parentR.children.length == 1)
        parent.unbind(parent.proxy(oldChild.parentR))

      val oldChildR = child.roleOf(oldChild.core)
      
      // unbind child role from oldChild 
      child.unbind(oldChild)
      
      children = children.filterNot(_ == oldChildR)
    }
  }
  
  trait Child extends Role[Core] {
    private[Composite] var parentR: Parent = null
    
    def getParent: Parent#Proxy = {
      parent.proxy(parentR)
    }
  }  
  
}
