module Dip::InfaWorkflowHelper
  def get_workflow_status(data)
    workflow_id=data[:workflow_id]
    run_id=data[:run_id]
    workflow=Dip::InfaWorkflow.find(workflow_id)
    repository=Dip::InfaRepository.find(workflow[:repository_id])
    sessionId=Dip::InfaRepository.login(repository)
    server=Dip::InfaRepository.get_a_diServer(repository, sessionId)
    details=Dip::InfaRepository.get_workflow_details_ex(repository, sessionId, workflow, server, run_id)
    Dip::InfaRepository.logout(repository, sessionId)
    details
  end

  def get_repository
    Dip::InfaRepository.order(:repository_alias).collect{|r|[r.repository_alias,r.id]}
  end
end
