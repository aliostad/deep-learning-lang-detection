package net.homework

import Direction._
import Movement._

case class Coordinates(val x:Int, val y:Int)

case class Position(val coordinates:Coordinates, val direction:Direction.Value){
	val directionMapping = Map(	NORTH -> Map(FORWARD->NORTH
										, LEFT -> WEST
										, RIGHT -> EAST)
							,SOUTH -> Map(FORWARD->SOUTH
										, LEFT -> EAST
										, RIGHT -> WEST)
							,EAST -> Map(FORWARD->EAST
										, LEFT -> NORTH
										, RIGHT -> SOUTH)
							,WEST -> Map(FORWARD->WEST
										, LEFT -> SOUTH
										, RIGHT -> NORTH)
						)
	def computeNextPosition(mv:Movement.Value):Position={
		val finalDirection = directionMapping(direction)(mv)
		val finalCoordinate = mv match {
		  case FORWARD => manageForwardMove(finalDirection)
		  case _  => this.coordinates
		}
		Position(finalCoordinate,finalDirection)
	}
	def manageForwardMove(finalDirection:Direction.Value):Coordinates={
	  val x = this.coordinates.x
	  val y = this.coordinates.y
	  finalDirection match {
	    case NORTH => Coordinates(x,y+1)
	    case SOUTH => Coordinates(x,y-1)
	    case EAST => Coordinates(x+1,y)
	    case WEST => Coordinates(x-1,y)
	  }
	}
	override def toString = {
	  this.coordinates.x + " " + this.coordinates.y + " " + this.direction
	}
}
case class Mower(val startPosition:Position,val lawn:Lawn){
  
  	require(startPosition.coordinates.x >= 0 && startPosition.coordinates.x <= lawn.upperRightCorner.x, s"The x position of the mower($startPosition) must be within the lawn boudary($lawn.upperRightCorner)")
	require(startPosition.coordinates.y>= 0 && startPosition.coordinates.y <= lawn.upperRightCorner.y, s"The y position of the mower($startPosition) must be within the lawn boudary($lawn.upperRightCorner)")
  
	def executeInstructions(instructions:List[Movement.Value]):Position={
	  def execInstr(pos:Position,instr:List[Movement.Value]):Position = {
	    if(instr == Nil)	pos 
	    else {
		      val posi = pos.computeNextPosition(instr.head)
		      val onLawnCoor = lawn.keepCoordinateOnTheLawn(posi.coordinates)
		      val np = Position(onLawnCoor,posi.direction)
		      execInstr(np,instr.tail)
	    	}
		}
	  execInstr(startPosition, instructions)
	}
}

case class Lawn(upperRightCorner:Coordinates){
	require(upperRightCorner.x >= 0, "a lawn must have a positive width")
	require(upperRightCorner.y >= 0, "a lawn must have a positive length")
	
	def keepCoordinateOnTheLawn(coor:Coordinates):Coordinates ={
	  val x = manageOutboundCoordinates(coor.x, upperRightCorner.x)
	  val y = manageOutboundCoordinates(coor.y, upperRightCorner.y)
	 Coordinates(x,y)
	}
	
	private def manageOutboundCoordinates(a:Int, upperLimit:Int)={
		if(a < 0) 0
		else if(a > upperLimit) upperLimit
		else a
	}
	
}
case class MowersOnLawnManager(lawnUpperRightCorner:Coordinates
		,mowersDirectives:List[(Position,List[Movement.Value])]){
	val lawn = Lawn(lawnUpperRightCorner)
			def printMowerEndPositions(){
		mowersDirectives.foreach{m =>
		val mower = Mower(m._1,lawn)
		val endPosition = mower.executeInstructions(m._2)
		println(endPosition)
		}
		
	}
}
