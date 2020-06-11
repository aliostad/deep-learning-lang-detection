/*
package connect4.bruno

import connect4.Color._
import connect4._
import scala.util.control.Breaks._
import scala.util.Random
object FastBoardImplTest extends BoardTest{

   override def dump(a:Any) : Unit = a match {
     case fastBoard:FastBoardImpl=>{System.out.println(fastBoard.toString());}
     case _=>super.dump(a);
   }
   
   def main(args : Array[String]) : Unit = {
    //  testAll(new FastBoardImpl())
	  //testSpeed(new FastBoardImpl(),30)
	  testHashCode(new FastBoardImpl())
   }
   
   
   def randomOps(board0:Board,n:Int,seed:Int):List[Integer]={
     var rnd=new Random(seed)	
    
       
     var board=board0
   
     var retVal=List[Integer]()
     
     breakable { for(i <- 0 until n){
	       var possibleMoves=board.possibleMoves()
	       if (possibleMoves.isEmpty)
	         break;
	        var indexChosen=(rnd.nextDouble()*possibleMoves.size).intValue();
           board=board.move(Color.Circle,possibleMoves(indexChosen))
           
           retVal::=possibleMoves(indexChosen)
	     }
     }
     retVal
   }
   
   def apply(board:Board,colorStart:Color,moves:List[Integer]):Board={
     
     var boarda=board
     var color=colorStart
     for(op <- moves){
       boarda=boarda.move(color,op)
       color=Color.invert(color)
     }
     boarda
   }
           
    def testHashCode(board:Board){        
     var moves=randomOps(board,20,0)
     var boarda=apply(board,Color.Circle,moves)
     assert(boarda.hashCode()==apply(board,Color.Circle,moves).hashCode())
     dump(boarda)
     
     
     var boardc:Board=new BoardImpl
     dump(boardc)
     boardc=apply(boardc,Color.Circle,moves.slice(0,10))
     dump(boardc)
     boardc=new FastBoardImpl().init(boardc)
     boardc=apply(boardc,Color.Circle,moves.slice(10,moves.size))
     dump(boardc)
     
     dump(boarda.hashCode())
     dump(boardc.hashCode())
     assert(boarda.hashCode()==boardc.hashCode())
     assert(boarda.equals(boardc))
     
     
     
     
   }
}
*/