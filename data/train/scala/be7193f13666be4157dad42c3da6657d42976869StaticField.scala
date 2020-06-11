package horse.core.fieldstate

import scala.collection.mutable.Set

import Horse._

class StaticField(  width: Int, height: Int, pos: Pos, 
                    dir: Direction.Value, plainShow: Show ) extends Field(width, height) {
    override def getPos = pos
    override def getDir = dir
    override def getShow = plainShow

    def equals(field: Field): Boolean = {
        if ((pos != field.getPos) || (dir != field.getDir)) 
           return false

        val otherShow = field.getShow
        if (show.size != otherShow.size) {
            println("Different show size")
            println(show)
            println(otherShow)
            return false
        }

        for (seg <- otherShow) {
            if (!show.contains(seg)) {
                println("I don't contain segment " + seg) 
                return false
            }
        }
        true
    }

    private def equals(p1: Pos, p2: Pos) = {
        (p1.x == p2.x) && (p1.y == p2.y)
    }

    private[this] def show: Set[(Pos, Pos)] = Set.empty ++ plainShow
}
