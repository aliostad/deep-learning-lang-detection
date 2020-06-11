package week2.stacks.and.queues

class LinkedQueueOfStrings {

  var first : Node = _
  var last : Node = _
  
  def isEmpty : Boolean =  {
    first == null
  }
  
  def enqueue(itemName : String) : Unit = {
    var oldLast : Node = last
    last = new Node(itemName , null)
    if(isEmpty)
    	first = last
    else
    	oldLast.next = last
  }
  
  def dequeue : String = {
    val item : String = first.itemName
    first = first.next
    if(isEmpty)
    	last = null
    
    item
  }
  
  class Node(val itemName : String , var next : Node) {}
}