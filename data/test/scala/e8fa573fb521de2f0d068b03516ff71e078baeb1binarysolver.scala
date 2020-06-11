import scala.collection.mutable

class BinarySolver(val minDepth: Int, val maxDepth: Int, timeout: Int) extends AbsSolver(timeout) with RecursiveSolver {
  def name = "BinarySolver"

  def checkCond(board: Board): Boolean = {
    board.wi * board.hi <= 12
  }

  def solve(board: Board, index: Int, old: Option[Board]): (Option[Board], Int) = {
    println(index + ":" + name + ": " + board + " md:" + board.manhattanDistance.sum)

    val hl = board.hand.length

    val maxDep = old match {
      case Some(b) => b.hand.length
      case None => maxDepth + hl
    }
    
    val minDep = minDepth + hl

    val res = (binSolve(minDep, maxDep, board, old, (b: Board) => { b.isSolved }), maxDep)

    res match {
      case (Some(b), _) => println(b)
      case (None, _) => println("notfound")
    }

    res
  }
}
