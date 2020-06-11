package legend.manfifests

import legend.datastructures.Process
import scala.collection.mutable.Map

/**
  * This manifest tracks all processes that are present in the scenario.
  *
  */
object ProcessManifest {

  val processes = Map[String,Process]()

  def register_process(p:Process) = {
    if(processes.contains(p.name)){
      throw DuplicateProcessName(s"Attempted to load at least two processes with name ${p.name} all process names must be unique.")
    }
    processes +=(p.name->p)
  }


}
case class DuplicateProcessName(message: String = "") extends Exception(message)