package ch.uzh.ifi.mamato.crowdSA.process

import ch.uzh.ifi.mamato.crowdSA.hcomp.crowdsa.CrowdSAQuery
import ch.uzh.ifi.mamato.crowdSA.model.Answer
import ch.uzh.ifi.pdeboer.pplib.process.entities._

/**
 * Created by mattia on 18.03.15.
 */

@PPLibProcess
class AssessmentProcess(_params: Map[String, Any] = Map.empty)
  extends CreateProcess[CrowdSAQuery, Answer](_params) {

  /**
   * Run an Assessment Process. This process will create all the questions to test if an assumption hold for a certain
   * statistical method.
   * @param data A query composed by HCompQuery and CrowdSAQueryProperties
   * @return The converged answer
   */
  override protected def run(data: CrowdSAQuery): Answer = {
    val processType = AssessmentProcess.ASSESSMENT_PROCESS.get

    val lowerPriorityParams = params

    val process = processType.create(lowerPriorityParams)
    process.process(data)
  }

  override def expectedParametersBeforeRun: List[ProcessParameter[_]] = List(AssessmentProcess.ASSESSMENT_PROCESS)
}

object AssessmentProcess {
  val ASSESSMENT_PROCESS = new ProcessParameter[PassableProcessParam[CreateProcess[CrowdSAQuery, Answer]]]("assessmentProcess", None)
}
