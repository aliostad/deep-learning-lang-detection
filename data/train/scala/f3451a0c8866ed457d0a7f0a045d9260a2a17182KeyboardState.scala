package scene.input

import scala.swing.event.Key

class KeyboardState {
  
  private val key_state = scala.collection.mutable.Map[Key.Value, Boolean]()
  private val old_key_state = scala.collection.mutable.Map[Key.Value, Boolean]()
  
  /**
   * Sets the specified key as pressed
   */
  def updateKeyPressed(key: Key.Value): Unit = key_state.put(key, true)
  
  /**
   * Sets the specified key as released
   */
  def updateKeyReleased(key: Key.Value): Unit = key_state.put(key, false)
  
  /**
   * Sets the internal old key state equals to the actual one
   */
  def updateOldState(): Unit = {
    old_key_state.clear()
    old_key_state ++= key_state
  }
  
  /**
   * @return True if the specified key is pressed, false otherwise
   */
  def isKeyDown(key: Key.Value): Boolean = {
    key_state.getOrElse(key, false)
  }

  /**
   * @return True if the specified key is up, false otherwise
   */
  def isKeyUp(key: Key.Value): Boolean = {
    !isKeyDown(key)
  }
  
  /**
   * @return True if the key wasn't pressed before a call to updateOldState 
   * and is pressed after 
   */
  def isNewKeyPress(key: Key.Value): Boolean = {
    isKeyDown(key) && !old_key_state.getOrElse(key, false) 
  }
  
  /**
   * @return true if the key was pressed before a call to updateOldState and 
   * isn't pressed after
   */
  def isNewKeyRelease(key: Key.Value): Boolean = {
    isKeyUp(key) && old_key_state.getOrElse(key, false)
  }
}