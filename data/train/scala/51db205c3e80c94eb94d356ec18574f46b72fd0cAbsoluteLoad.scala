package pl.jaca.cluster.distribution

/**
 * @author Jaca777
 *         Created 2015-09-13 at 15
 */
/**
 * Load expressed with a single float.
 * @param initialLoad Initial load value. It can't be negative (use NegativeLoad if necessary).
 */
class AbsoluteLoad(initialLoad: Float) extends PrivilegedLoad {

  private var load: Float = 0
  setLoad(initialLoad)

  override def compareTo(load: Load): Int = load match {
    case AbsoluteLoad(cLoad) =>
      Math.floor(this.load - cLoad).toInt
    case l => l.compareTo(this)
  }

  def getLoad: Float = load

  def setLoad(load: Float) = {
    if (load < 0) throw new IllegalArgumentException("Load can't be negative")
    this.load = load
  }

  override def increase(load: Load) = load match {
    case AbsoluteLoad(f) =>
      this.load += f
  }

}

object AbsoluteLoad {
  def unapply(load: AbsoluteLoad): Option[Float] = {
    if (load.isInstanceOf[NegativeLoad.type]) Some(-1)
    else Some(load.getLoad)
  }
  def apply(load: Float) = new AbsoluteLoad(load)
}

/**
 * Negative absolute load. It's always lower than instance of AbsoluteLoad and equal to itself.
 */
object NegativeLoad extends AbsoluteLoad(0) {
  override def compareTo(load: Load): Int = load match {
    case AbsoluteLoad(i) =>
      if (i >= 0) -1
      else 0
    case _ => -1
  }


  override def setLoad(load: Float) {}

  override def getLoad: Float = -1
}
