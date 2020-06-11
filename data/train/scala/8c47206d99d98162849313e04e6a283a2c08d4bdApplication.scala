package controllers

import play.api._
import play.api.mvc._

object Application extends Controller {

  def index = Action {
    Ok("Application ready")
  }

  /**
    * Starts a new process instance for the loan approval process, with the given loan amount.
   */
  def startLoanApprovalProcess(loanAmount: Int) = Action {
    import org.camunda.bpm.engine.ProcessEngines
    import org.camunda.bpm.engine.variable.Variables._
    Logger.info("Starting process...")
    val runtime = ProcessEngines.getDefaultProcessEngine.getRuntimeService
    val processVariables = createVariables().putValueTyped("Loan amount", integerValue(loanAmount))
    val processInstance = runtime.startProcessInstanceByKey("approve-loan", processVariables)
    Created("started process instance " + processInstance.getId)
  }
}