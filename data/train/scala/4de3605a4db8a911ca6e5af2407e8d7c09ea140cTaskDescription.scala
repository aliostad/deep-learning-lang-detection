package ca.usask.agents.macrm.common.records

import ca.usask.agents.macrm.common.records._
import org.joda.time._
import java.io.Serializable
import akka.actor._

@SerialVersionUID(100L)
case class TaskDescription(val jobManagerRef: ActorRef,
                           val jobId: Long,
                           val index: Int,
                           val duration: Duration,
                           val resource: Resource,
                           val relativeSubmissionTime: Duration,
                           val constraints: List[Constraint],
                           val userId: Int = -1) extends Serializable {

    override def toString() = "<index:" + index.toString() + " duration:" + duration.getMillis.toString() + " resource:" +
        resource.toString() + " relSubTime:" + relativeSubmissionTime.getMillis.toString() + " contraints:[" +
        constraints.foreach(x => x.toString()) + "]>"
}

object TaskDescription {
    def apply(jobManagerRef: ActorRef, jobId: Long,  oldTD: TaskDescription, userId: Int) =
        new TaskDescription(jobManagerRef, jobId, oldTD.index, oldTD.duration, oldTD.resource, oldTD.relativeSubmissionTime, oldTD.constraints, userId)
}