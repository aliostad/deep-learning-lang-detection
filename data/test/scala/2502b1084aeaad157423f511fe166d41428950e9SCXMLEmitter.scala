/*******************************************************************************
* Copyright (c) 2016 Andreas Wagner.
* All rights reserved. This program and the accompanying materials
* are made available under the terms of the Eclipse Public License v1.0
* which accompanies this distribution, and is available at
* http://www.eclipse.org/legal/epl-v10.html
* 
* Contributors:
*     Andreas Wagner - Concept and implementation
*     Christian Prehofer - Concept
*******************************************************************************/
package mctt.emitter.scxml

/**
 * This singleton prints a state machine to a file.
 * It uses the standardized SCXML format as described here:
 * http://www.w3.org/TR/scxml/
 * @author Andreas Wagner
 */
import mctt.statemachine._
import java.io.{PrintWriter, File}

object SM2SCXML{
  
  var visited:Set[SMConnectable] = Set.empty[SMConnectable]
  
  def dump(part: SMConnectable, path: File, filename: String) {
    visited = Set.empty[SMConnectable]
    val pw = new PrintWriter(new File(path, filename))
    pw.println(header.format(part.asInstanceOf[State].toString()))
    dumpRec(part, pw)
    pw.println(footer)
    pw.close()
  }
  
  def dumpRec(part: SMConnectable, writer: PrintWriter) {
    if(!visited.contains(part)){
      if (part.isInstanceOf[ParallelState]){
        val state = part.asInstanceOf[ParallelState]
        if( state.parent != null && !visited.contains(state.parent)){
          dumpRec(state.parent, writer)
        }
        else{
          writer.println("<parallel id=\"" + state.toString() + "\">")
          visited+=part
          state.outgoingTransitions.foreach { x =>  
            writer.println("<transition event=\"" + x.toString() + "\" target=\"" + x.next.toString() + "\"/>")  
          }
          writer.println("<onexit>")
          state.exitActions.foreach { x =>
            writer.println(x.toString)
          }
          writer.println("</onexit>")
          state.substates.foreach { x => 
            dumpRec(x, writer)
          }
          writer.println("</parallel>")
          state.outgoingTransitions.foreach { x =>
            dumpRec(x.next, writer)
          }
        }
      }
      else if (part.isInstanceOf[CompoundState]){
        //compound state
        val state = part.asInstanceOf[CompoundState]
        if( state.parent != null && !visited.contains(state.parent)){
          dumpRec(state.parent, writer)
        }
        else{
          writer.println("<state id=\"" + state.toString() + "\"" + " initial=\"" + state.substates.head.toString() + "\">")
          visited+=part
          state.outgoingTransitions.foreach { x =>  
            writer.println("<transition event=\"" + x.toString() + "\" target=\"" + x.next.toString() + "\"/>")  
          }
          writer.println("<onexit>")
          state.exitActions.foreach { x =>
            writer.println(x.toString)
          }
          writer.println("</onexit>")
          dumpRec(state.substates.head, writer)
          writer.println("</state>")
          state.outgoingTransitions.foreach { x =>
            dumpRec(x.next, writer)
          }
        }
      }
      else if(part.isInstanceOf[SimpleState]){
        //a simple state
        val state = part.asInstanceOf[SimpleState]
        if( state.parent != null && !visited.contains(state.parent)){
          dumpRec(state.parent, writer)
        }
        else{
          val statetype = if(state.isfinal) "final" else "state"
          writer.println("<" + statetype + " id=\"" + state.toString() + "\">")
          visited+=part
          state.outgoingTransitions.foreach { x =>  
              writer.println("<transition event=\"" + x.toString() + "\" target=\"" + x.next.toString() + "\"/>")  
          }
          writer.println("<onexit>")
          state.exitActions.foreach { x =>
            writer.println(x.toString)
          }
          writer.println("</onexit>")
          writer.println("</" + statetype + ">")
          state.outgoingTransitions.foreach { x =>
            dumpRec(x.next, writer)  
          }
        }
      }
    }
  }
  
  def header = 
    "<scxml version=\"1.0\" xmlns=\"http://www.w3.org/2005/07/scxml\" initial=\"%s\">"
  
  def footer = 
    "</scxml>"
  
}