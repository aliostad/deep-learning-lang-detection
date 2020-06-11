package com.mygdx.managers

/**
 * @author Theo Stone
 */

object GameKeys
{
  private val numKeys: Int = 8
  private var newKeys = new Array[Boolean](numKeys)
  private var oldKeys = new Array[Boolean](numKeys)

  val UP = 0
  val DOWN = 1
  val LEFT = 2
  val RIGHT = 3
  val ENTER = 4
  val ESCAPE = 5
  val SPACE = 6
  val SHIFT = 7

  def update(): Unit =
  {
    for(i <- 0 until numKeys)
      oldKeys(i) = newKeys(i)
  }

  def setKey(k: Int, b: Boolean): Unit =
  {
    newKeys(k) = b
  }

  def isDown(k: Int): Boolean = newKeys(k)

  def isPressed(k: Int): Boolean = newKeys(k) && !oldKeys(k)
}
