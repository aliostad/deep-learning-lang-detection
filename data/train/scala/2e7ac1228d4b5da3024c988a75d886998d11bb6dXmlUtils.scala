package wechat7.util
import scala.xml._
import scala.xml.transform._
object XmlUtils {
  
  def addChild(oldXML:Node,parentName:String,newChild:Node):Node ={
   val newXML = new RuleTransformer(new AddChildrenTo(parentName, newChild)).transform(oldXML).head
    newXML
  }
  
  def addChildren(oldXML:Node,parentName:String,newChildren:Seq[Node]):Node ={
    def add(oldNode:Node,newNode:Node) :Node ={
      addChild(oldNode,parentName,newNode)
    }
    
    val seq=  Seq(oldXML) ++ newChildren
    println( seq)
    val newXML =seq.reduceLeft(add)
    newXML
  }
}

 

class AddChildrenTo(label: String, newChild: Node) extends RewriteRule {
  def addChild(n: Node, newChild: Node) = n match {
  case Elem(prefix, label, attribs, scope, child @ _*) =>
    Elem(prefix, label, attribs, scope, child ++ newChild : _*)
  case _ => error("Can only add children to elements!")
}
 
  override def transform(n: Node) = n match {
    case n @ Elem(_, `label`, _, _, _*) => addChild(n, newChild)
    case other => other
  }
}