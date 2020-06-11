package freeeventsourcing.syntax

import scala.language.implicitConversions
import freeeventsourcing.api.domainmodel.{ DomainModel, EventSelector, EventWithMetadata, ProcessDefinition }
import freeeventsourcing.api.domainmodel.EventSelector._
import freeeventsourcing.api.domainmodel.eventselector.ValidSelector

/** Helps defining a process definition with an easier syntax.
 *  <code>
 *   object MyProcess extends ProcessHelper(MyBoundedContext, "MyProcess")(mySelector) {
 *     protected[this] case class Instance(event: Event) extends ProcessInstance {
 *       import syntax._
 *       def process = (...)
 *     }
 *   }
 *  </code>
 */
abstract class ProcessHelper[DM <: DomainModel, S <: WithEventType: EventSelector: ValidSelector[DM, ?]](domainModel: DM, name: String)(selector: S) {
  val definition: ProcessDefinition[DM] = ProcessDefinition(domainModel, name)(selector)(e ⇒ Instance(e).process)

  protected type Event = EventWithMetadata[S#Event]
  protected type Instance <: ProcessInstance
  protected[this] val Instance: Event ⇒ Instance

  protected[this] abstract class ProcessInstance {
    protected[this] val syntax = ProcessSyntax(domainModel)
    def process: ProcessDefinition.ProcessMonad[DM, _]
  }
}
object ProcessHelper {
  implicit def helperToDefinition[DM <: DomainModel](h: ProcessHelper[DM, _]): ProcessDefinition[DM] =
    h.definition
  implicit def helperListToDefinitionList[DM <: DomainModel](hs: List[ProcessHelper[DM, _]]): List[ProcessDefinition[DM]] =
    hs.map(helperToDefinition)
}