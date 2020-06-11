package org.scylo.algo

import org.scylo.bio._
import org.scylo.evo.EvoModel
import org.scylo.tree._

case class Felsenstein[A]( model: EvoModel[A] ) {

  def likelihood(tree: Tree[Nuc]): Double = {
    import model._
    
    def traverse(tree: Tree[Nuc]): Array[Double] = {
      tree match {
        case Branch(timeL, left, timeR, right) =>
          val distL = traverse(left)
          val distR = traverse(right)
          val dist = new Array[Double](4)
          for (old <- alphabet.elements ) {
            for ( nuc1 <- alphabet.elements; nuc2 <- alphabet.elements ) {
              dist( alphabet.toInt(old) ) += 
              substitutionProb(old, nuc1, timeL) * distL(alphabet.toInt(nuc1)) * 
              substitutionProb(old, nuc2, timeR) * distR(alphabet.toInt(nuc2))
            }
          }
          dist
        case Leaf(nuc1) => nuc1 match {
          case A => Array(1.0, 0.0, 0.0, 0.0)
          case C => Array(0.0, 1.0, 0.0, 0.0)
          case G => Array(0.0, 0.0, 1.0, 0.0)
          case T => Array(0.0, 0.0, 0.0, 1.0)
        }
      }
    }
    val rootDist = traverse(tree)
    var sum = 0.0
    for( nuc <- alphabet.elements ) {
      sum += rootDist( alphabet.toInt( nuc ) ) * model.statDist( nuc ) 
    }
    sum
  }
}

