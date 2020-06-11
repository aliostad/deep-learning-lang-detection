package com.sos.scheduler.engine.client.api

import com.sos.scheduler.engine.data.agent.AgentAddress
import com.sos.scheduler.engine.data.event.Snapshot
import com.sos.scheduler.engine.data.processclass.{ProcessClassPath, ProcessClassView}
import com.sos.scheduler.engine.data.queries.PathQuery
import scala.collection.immutable
import scala.concurrent.Future

/**
  * @author Joacim Zschimmer
  */
trait ProcessClassClient {
  def agentUris: Future[Snapshot[Set[AgentAddress]]]

  def processClasses[V <: ProcessClassView: ProcessClassView.Companion](query: PathQuery): Future[Snapshot[immutable.Seq[V]]]

  def processClass[V <: ProcessClassView: ProcessClassView.Companion](processClassPath: ProcessClassPath): Future[Snapshot[V]]
}
