namespace Amazon.SimpleWorkflow.Extensions

module Constants =
    // see http://docs.aws.amazon.com/amazonswf/latest/apireference/API_RegisterDomain.html
    let minWorkflowExecRetentionPeriodInDays = 1
    let maxWorkflowExecRetentionPeriodInDays = 8

    // see http://docs.aws.amazon.com/amazonswf/latest/apireference/API_RespondActivityTaskFailed.html
    let maxDetailsLength = 32768
    let maxReasonLength  = 256

    // see http://docs.aws.amazon.com/amazonswf/latest/apireference/API_RespondDecisionTaskCompleted.html
    let maxExecutionContextLength = 32768

    // see http://docs.aws.amazon.com/amazonswf/latest/apireference/API_RespondActivityTaskCompleted.html
    let maxResultLength           = 32768