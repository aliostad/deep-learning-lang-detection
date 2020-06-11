package spacemule.helpers

trait Trackable {
  // Initialize our initial values.
  private var attributes = trackedAttributes

  /**
   * Retrieve Map of tracked attributes.
   */
  protected def trackedAttributes: Map[String, Any]

  /**
   * Resets tracked attributes to track current values.
   */
  def resetTracking() = attributes = trackedAttributes

  /**
   * Returns map of changed attributes.
   */
  def changes: Map[String, Tuple2[Any, Any]] = {
    trackedAttributes.map { case(key, value) =>
        val oldValue = attributes(key)
        if (oldValue != value) {
          Some(key -> (oldValue, value))
        }
        else {
          None
        }
    }.flatten.toMap
  }
}

