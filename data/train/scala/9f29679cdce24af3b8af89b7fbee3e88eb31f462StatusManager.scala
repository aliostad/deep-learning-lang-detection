package com.takashabe.deokure

import android.content.SharedPreferences

/**
 * manage "Route List", "Delay Routes", "Search delay query" in SharedPreferences.
 */
case class StatusManager(sp: SharedPreferences) {
  private val ed = sp.edit()

  def setStatusList(kv: List[(String, String)]) = {
    kv map(x => ed.putString(x._1, x._2))
    ed.commit()
  }

  def deleteStatus(key: List[String]) = {
    key map(x => ed.remove(x))
    ed.commit()
  }

  def findDelayStatus(key: String): String = {
    sp.getString(key, "none")
  }

  def findUpdateTime(key: String): Long = {
    sp.getLong(key, -1L)
  }
}