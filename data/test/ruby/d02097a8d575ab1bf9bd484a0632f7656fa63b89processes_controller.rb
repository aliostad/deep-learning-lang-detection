class Api::V1::ProcessesController < Api::ApiController

  def index
    pds = ProcessEngine::ProcessQuery.process_definition_get_all
    render json: { process_definitions: pds.map{ |pd| pd.attributes.slice("id", "name", "slug", "description", "created_at", "updated_at")} }
  end

  def start
    # param input
    @process_definition = ProcessEngine::ProcessDefinition.find(params[:id])
    pi = ProcessEngine::ProcessQuery.process_instance_start(@process_definition.slug, "user_#{@user.id}")
    render json: pi.attributes.slice("id", "status",  "states", "creator", "created_at", "updated_at")
  end

end
