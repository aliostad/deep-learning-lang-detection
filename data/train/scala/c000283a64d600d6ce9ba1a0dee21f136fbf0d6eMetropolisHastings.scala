package org.lanyard.inference

import org.lanyard.Measure
import org.lanyard.random.RNG
import org.lanyard.random.Random

case class MetropolisHastings[A](  proposal: A => Measure[A] with Random[A], target: Measure[A] ) {

  sealed trait Decision
  case object Accepted extends Decision
  case object Rejected extends Decision

  case class State( value: A, decision: Decision )

  def step( state: State , rng: RNG): (State, RNG) = {

    val propGivenOld = proposal( state.value )
    val (candidate, tmpRng) = propGivenOld.random( rng ) // draw from proposal given old state
    val propGivenNew = proposal( candidate )

    val targetNew = target.logLike( candidate )
    val targetOld = target.logLike( state.value )
    val propNew = propGivenNew.logLike( state.value )
    val propOld = propGivenOld.logLike( candidate )

    val (doub, nextRng) = tmpRng.nextDouble
    val acceptProb = math.min( 0.0 , targetNew + propNew - targetOld - propOld )

    if( acceptProb > math.log(doub) ) {
      ( State( candidate, Accepted ), nextRng)
    } else {
      ( State( state.value, Rejected), nextRng)
    }
  }

  def stream( init: A, rng: RNG): Stream[State] = {
    def recc( state: State, rng: RNG ): Stream[State] = {
      val ( newState, newRNG ) = step( state, rng)
        state #:: recc( newState, newRNG )
    }
    recc( State( init, Accepted), rng)
  }

}














