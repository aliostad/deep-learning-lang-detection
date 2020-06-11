package net.malevy

object Driver extends App{

  override def main(args : Array[String]) {

    var universe = Universe.makeRandom(10, 20)
    while(true) {
      dump(universe)
      universe = universe.evolve()
    }
  }

  def dump(universe: Universe) : Unit = {
    var currentRow: Int = -1
    val sb = new StringBuilder()
    universe.iterate((row:Int, col:Int, state:Int) => {
      if (row != currentRow) {
        sb.append("\n")
        currentRow = row
      }
      sb.append(state).append(" ")
    })
    sb.append("\n")

    println(sb.toString())
  }

}




