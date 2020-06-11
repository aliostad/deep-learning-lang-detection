package com.signalcollect.dcop.graph

import com.signalcollect._
import com.signalcollect.dcop.modules.Optimizer
import com.signalcollect.dcop.modules.Configuration

/**
 * The Vertex state is of type Config.
 */
trait DcopConvergenceDetection[AgentId, Action, Config <: Configuration[AgentId, Action], UtilityType] {
  this: DataGraphVertex[AgentId, Config] =>

  val optimizer: Optimizer[AgentId, Action, Config, UtilityType]

  def isConverged(c: Config): Boolean = {
    optimizer.shouldTerminate(c)
  }

  def currentConfig: Config

  def isStateUnchanged(oldConfig: Config, newConfig: Config): Boolean = {
    oldConfig.centralVariableAssignment == newConfig.centralVariableAssignment &&
      oldConfig.neighborhood == newConfig.neighborhood
  }

  override def scoreSignal: Double = {
    if (edgesModifiedSinceSignalOperation) {
      1
    } else {
      lastSignalState match {
        case Some(oldState) => {
          if (isStateUnchanged(oldState, state) && isConverged(state)) {
            //println("=>" + state)
            0
          } else {
            1
          }
        }
        case noStateOrStateChanged => 1
      }
    }
  }
}
