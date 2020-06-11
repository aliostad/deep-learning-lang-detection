package com.jamesrthompson.games

import scala.collection.mutable.HashMap


class Board(pieceMap: HashMap[Pos, Piece], var state: PieceColor) {
  
  def pieceAt(p: Pos) : Option[Piece] = pieceMap.get(p)

  def deletePiece(p: Pos) {
    pieceAt(p) match {
      case sp:Some[Piece] => pieceMap.remove(p)
      case None => ()
    }
  }

  def movePiece(oldPos: Pos, newPos: Pos) {
    pieceAt(oldPos) match {
      case sp:Some[Piece] => {
        val p = sp.get
        pieceAt(oldPos).get.moveTo(newPos)
        pieceMap.update(newPos, pieceAt(oldPos).get)
        deletePiece(oldPos)
      }
      case None => ()
    }
  }

  def showBoard : Unit = {
    println("\n\n\n      A  B  C  D  E  F  G  H")
    println("      ----------------------")
    for(i <- 0 to 7) {
      print(" " + (i + 1).toString + " | ")
      for(j <- 0 to 7) {
        print(pieceAt(Pos(i,j)).getOrElse(" . "))
      }
      if(i < 7 && i == 3) println("\tWhite score = " + boardScoreForColor(White) +"\n   |") else if(i < 7 && i == 4) {
        println("\tBlack score = " + boardScoreForColor(Black) +"\n   |")
      } else if(i < 7) println("\n   |")
    }
  }

  def listPieces = pieceMap.foreach(println)

  def totalBoardScore = pieceMap.par.map(_._2.pieceScore).sum

  def boardScoreForColor(pc: PieceColor) = pieceMap.view.filter(_._2.pcolor == pc).map(_._2.pieceScore).sum

  def evalBoard = boardScoreForColor(White) - boardScoreForColor(Black)

  def copyBoard = pieceMap.clone

  def piecesForColorState = pieceMap.view.filter(_._2.pcolor == state).map(_._2).toList

  def changeState = state = otherState

  def otherState = state match {
    case White => Black
    case Black => White
  }

  def nextBoardStates : List[Board] = piecesForColorState.flatMap(makeHashMaps(_))

  def makeHashMaps(oldPiece: Piece) : List[Board] = {
    val locationVectors = oldPiece.possibleMoveLocations
    val possLocations = oldPiece.ptype match {
      case Knight => locationVectors.view.filter(coord => notColor(oldPiece.pcolor, coord))
      case King   => locationVectors.view.filter(coord => notColor(oldPiece.pcolor, coord))
      case Pawn   => {
        val pawn1    = Utils.addPair(oldPiece.pos, Pos(oldPiece.direction, 0))
        val listPos  = List[Pos](Pos(oldPiece.direction, 1), Pos(oldPiece.direction, -1))
        val check    = listPos.map(targ => Utils.addPair(oldPiece.pos, targ)).view.filter(c => oppositePiece(oldPiece.pcolor, c)).toList
        if(empty(pawn1)) pawn1 :: check else check
      }
      case Bishop => locationVectors.flatMap(iterateDirection(1, oldPiece.pos, oldPiece.pcolor, _))
      case Rook   => locationVectors.flatMap(iterateDirection(1, oldPiece.pos, oldPiece.pcolor, _))
      case Queen  => locationVectors.flatMap(iterateDirection(1, oldPiece.pos, oldPiece.pcolor, _))
    }
    val newHashMaps = for(newLoc <- possLocations) yield {
      val nb = copyBoard
      val newPiece = new Piece(oldPiece.pcolor, oldPiece.ptype, newLoc)
      nb.update(newLoc, newPiece)
      nb.remove(oldPiece.pos)
      nb
    }
    newHashMaps.toList.map(newHM => new Board(newHM, state))
  }

  def notColor(color: PieceColor, locale: Pos) = pieceAt(locale) match {
    case sp:Some[Piece] => sp.get.pcolor != color
    case None => true
  }

  def oppositePiece(color: PieceColor, p: Pos) = {
    lazy val oppositeColor = color match {
      case White => Black    
      case Black => White
    }
    pieceAt(p) match {
      case sp:Some[Piece] => if(sp.get.pcolor == oppositeColor) true else false
      case None => false
    }
  }

  def empty(p: Pos) = pieceAt(p) match {
    case None => true
    case sp:Some[Piece] => false
  }

  def iterateDirection(n: Int, p: Pos, color: PieceColor, r: Pos) : List[Pos] = {
    val aimsAt = Utils.addPair(Utils.multPair(n, r), p)
    if(Utils.insideBoard(aimsAt) == false) List[Pos]() else {
      pieceAt(aimsAt) match {
        case None           => aimsAt :: iterateDirection(n+1, p, color, r)
        case sp:Some[Piece] => if(color == sp.get.pcolor) List[Pos]() else List[Pos](aimsAt)
      }
    }
  }
}


object BoardBuilder {

  def makeBoard(in: List[String], pcStart: PieceColor) : Board = {
    require(in.length == 8, "Initialization board incorrect length, please try again")
    val inPieces = for(i <- 0 until 8; j <- 0 until 8) yield readSquare(in(i)(j), Pos(i, j))
    val startPieces = inPieces collect {case sp:Some[Piece] => sp.get}
    new Board(new HashMap[Pos, Piece]() ++ startPieces.map(sp => (sp.pos, sp)), pcStart) // Always starts with white
  }

  implicit def indexPos(i: Int) : Pos = Pos(i >> 8, i & 7)

  private def readSquare(in: Char, p: Pos) : Option[Piece] = {
    val c = if(in.isUpper) White else Black
    in.toUpper match {
      case 'P' => Some(new Piece(c, Pawn, p))
      case 'N' => Some(new Piece(c, Knight, p))
      case 'B' => Some(new Piece(c, Bishop, p))
      case 'R' => Some(new Piece(c, Rook, p))
      case 'Q' => Some(new Piece(c, Queen, p))
      case 'K' => Some(new Piece(c, King, p))
      case  _  => None
    }
  }
}