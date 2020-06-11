/**
 * Class Particle involves the coordinates in its constructor.
 * There is no need to implement a getter or setter, because scala
 * already manage those implementations.
 */
class Particle2(val id: Int, var rx: Double, var ry: Double, var vx: Double, var vy: Double ) {

  // mass of a particle
  var mass = 0.031998

  // radius of a particle
  var radius = 0.0001

  // the acceleration a particle experiences
  var acceleration = 0

  // the force a particle experiences
  var force = 0

  private val counter = new SafeCounter

  def getCollisions() = {
      counter.increment(1)
  }
}
