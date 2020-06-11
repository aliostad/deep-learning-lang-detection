class ProcessDefinitionsController < ApplicationController
  def index
    @process_definitions = mq_request 'process_definition.index', 'process_definition.indexed', {}
    render json: @process_definitions
  end

  def show
    @process_definition = mq_request 'process_definition.show', 'process_definition.showed', id: params[:id]
    render json: @process_definition
  end

  def create
    @process_definition = mq_request 'process_definition.create', 'process_definition.created', process_definition: process_definition_params
    render json: @process_definition, status: :created
  end

  def update
    @process_definition = mq_request 'process_definition.update', 'process_definition.updated', process_definition: process_definition_params, id: params[:id]
    render json: @process_definition
  end

  def destroy
    mq_request 'wfms.process_definition.destroy', 'wfms.process_definition.destroyed', id: params[:id]
    head :no_content
  end

  private
    def process_definition_params
      params.require(:process_definition).permit(:workflow_id)
    end
end
