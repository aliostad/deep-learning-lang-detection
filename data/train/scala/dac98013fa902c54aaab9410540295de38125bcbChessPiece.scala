package chess
import Color._

abstract class ChessPiece {
  val color: Color.Value

  def isValidMove(oldPos: Pos, newPos: Pos): Boolean
}

case class Pawn(color: Color.Value) extends ChessPiece{
  def isValidMove(oldPos: Pos, newPos: Pos) =
    color match {
      case Black => oldPos.down == newPos
      case White => oldPos.up == newPos
    } // also check if first move

  override def toString = color match{
    case White => "\u2659"
    case Black => "\u265F"
  }
}

case class Rook(color: Color.Value) extends ChessPiece{
  def isValidMove(oldPos: Pos, newPos: Pos) = {
    oldPos.onSameCol(newPos) || oldPos.onSameRow(newPos)
  }
  override def toString = color match{
    case White => "\u2656"
    case Black => "\u265C"
  }
}

case class Bishop(color: Color.Value) extends ChessPiece{
  def isValidMove(oldPos: Pos, newPos: Pos) = {
    oldPos.onSameDiagonal(newPos)
  }
  override def toString = color match{
    case White => "\u2657"
    case Black => "\u265D"
  }
}

case class Queen(color: Color.Value) extends ChessPiece{
  def isValidMove(oldPos: Pos, newPos: Pos) = {
    oldPos.onSameCol(newPos) || oldPos.onSameRow(newPos) || oldPos.onSameDiagonal(newPos)
  }
  override def toString = color match{
    case White => "\u2655"
    case Black => "\u265B"
  }
}

case class King(color: Color.Value) extends ChessPiece{
  def isValidMove(oldPos: Pos, newPos: Pos) = {
    oldPos.right == newPos || oldPos.left == newPos || oldPos.up == newPos || oldPos.down == newPos ||
    oldPos.right.down == newPos || oldPos.right.up == newPos || oldPos.left.down == newPos ||
    oldPos.left.up == newPos
  }
  override def toString = color match{
    case White => "\u2654"
    case Black => "\u265A"
  }
}

case class Knight(color: Color.Value) extends ChessPiece{
  def isValidMove(oldPos: Pos, newPos: Pos) = {
    val xDifferential = (newPos.file - oldPos.file).abs
    val yDifferential = (newPos.file - oldPos.file).abs
    (xDifferential == 1 && yDifferential == 2) || (xDifferential == 2 && yDifferential == 1)
  }
  override def toString = color match{
    case White => "\u2658"
    case Black => "\u265E"
  }
}