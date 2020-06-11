package util

import collection.mutable

import models.Activity

object ActivityManager {

  /** The global list of all registered activities (accessible by their ID). */
  val activities = mutable.Map.empty[Int, Activity]
  private var idCounter = 0

  /** Gets the list of activities owned by the specified user. */
  def getUserActivities(username: String) = activities.values.filter(activity => activity.username == username)

  /**
   * Adds the given activity to the global activities list and assigns it an ID
   * that could be used to manage it. Returns the ID.
   *
   * Currently, this method is called from the Activity class constructor (and
   * shouldn't be called from elsewhere).
   */
  def registerNewActivity(activity: Activity): Int = {
    idCounter += 1
    val id = idCounter
    activities(id) = activity
    id
  }
}