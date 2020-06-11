import scala.util.Random

case class AsteroidsBoard(val emptySpace: EmptySpaceBoard, val amount: Int) extends Board{
  lazy val value: List[Vertex] = {
    def loop(restAmount: Int, possibilities: List[Vertex], newSpace: List[Vertex]): List[Vertex] = {
      if (restAmount == 0) {
        newSpace
      } else {
        val randVertex = Random.shuffle(possibilities).head
        val oldVertex = newSpace.filter(vertex => vertex.x == randVertex.x && vertex.y == randVertex.y).head
        val newVertex = new Asteroid(oldVertex.x, oldVertex.y)
        val updatedSpace = newSpace.updated(newSpace.indexOf(oldVertex), newVertex)

        loop(restAmount - 1, possibilities.filterNot(ver => ver == randVertex),updatedSpace)
      }
    }
    loop(amount, possibleVertexes, emptySpace.value)
  }

  def possibleVertexes: List[Vertex] = {
    emptySpace.value.filterNot(v => v == emptySpace.start || v == emptySpace.end)
  }

  val start = emptySpace.start
  val end = emptySpace.end
  val spaceDimension = emptySpace.spaceDimension
}
