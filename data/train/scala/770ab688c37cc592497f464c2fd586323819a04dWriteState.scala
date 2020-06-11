package main.scala.Fauxquet

/**
  * Created by james on 1/9/17.
  */
abstract class WriteState {
  def start(): WriteState = ???
  def stop(): WriteState = ???
  def startBlock(): WriteState = ???
  def startColumn(): WriteState = ???
  def write(): WriteState = ???
  def endBlock(): WriteState = ???
  def endColumn(): WriteState = ???
  def end(): WriteState = ???
}

object NOT_STARTED extends WriteState {
  override def start(): WriteState = STARTED
}

object STARTED extends WriteState {
  override def startBlock(): WriteState = BLOCK
  override def end(): WriteState = ENDED
}

object BLOCK extends WriteState {
  override def startColumn(): WriteState = COLUMN
  override def endBlock(): WriteState = STARTED
}

object COLUMN extends WriteState {
  override def endColumn(): WriteState = BLOCK
  override def end(): WriteState = COLUMN

  override def write(): WriteState = this
}

object ENDED extends WriteState { }