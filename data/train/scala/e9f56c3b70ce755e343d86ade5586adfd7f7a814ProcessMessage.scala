package fr.limsi.iles.cpm.process

/**
 * Created by buiquang on 10/6/15.
 */

object ProcessMessage{

  implicit def parse(message:String) : ProcessMessage = {
    val components = message.split("\n")
    if(components.size>=3){
      new ValidProcessMessage(components(0),components(1),components.slice(2,components.length).foldLeft("")((agg,line)=>{agg+"\n"+line}).trim)
    }else{
      new InvalidProcessMessage()
    }
  }

  implicit def toString(message:ProcessMessage) : String = {
    message.toString()
  }
}

class ProcessMessage

case class ValidProcessMessage(val sender:String,val status:String,val exitval:String) extends ProcessMessage{

  override def toString(): String = {
    sender+"\n"+status+"\n"+exitval
  }
}

case class InvalidProcessMessage() extends ProcessMessage

