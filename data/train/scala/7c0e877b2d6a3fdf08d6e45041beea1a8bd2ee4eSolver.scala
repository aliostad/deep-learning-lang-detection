package ru.biocad.game


object Solver {

  def dump(states: Vector[BoardState]): String = {
    states.foldLeft("")((acc, bs) => acc + bs.dump + "\n")
  }

  def isActive(c: Cell, b: BoardState): String = {
    if (b.filled.contains(c)) "active"
    else "disabled"
  }

  def dumpStateForFront(state: BoardState, board: Board): String = {

    val res: Vector[String] = for {
      cell <- board.cells.map(c => (c, isActive(c, state)))
    } yield {
      s"""
         |{
         |"posX": ${cell._1.q}
         |"posY": ${cell._1.r}
         |"state" ${cell._2}
         |}
       """.stripMargin
    }

    res.foldLeft("")((acc, r) => acc + r + "\n")

  }

}
