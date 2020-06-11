class ProcessFlowsController < ApplicationController
  before_action :set_process_flow, only: [:show, :edit, :update, :destroy]
  before_filter :set_page_info

  autocomplete :process_flow, :process_name, :full => true

  def set_page_info
    @menus[:quality][:active] = "active"
  end

  # GET /process_flows
  # GET /process_flows.json
  def index
    @process_flows = ProcessFlow.joins(:attachment).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        @process_flows = @process_flows.collect{|process_flow| 
        attachment = process_flow.attachment.attachment_fields
        attachment[:attachment_name] = CommonActions.linkable(process_flow_path(process_flow), attachment.attachment_name)
        attachment[:links] = CommonActions.object_crud_paths(nil, edit_process_flow_path(process_flow), nil)
        attachment
        }
        render json: { :aaData => @process_flows } 
      }
    end
  end

  # GET /process_flows/1
  # GET /process_flows/1.json
  def show
    @attachment = @process_flow.attachment
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @process_flow }
    end
  end

  # GET /process_flows/new
  # GET /process_flows/new.json
  def new
    @process_flow = ProcessFlow.new
    @process_flow.build_attachment

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @process_flow }
    end
  end

  # GET /process_flows/1/edit
  def edit
    @attachment = @process_flow.attachment
  end

  # POST /process_flows
  # POST /process_flows.json
  def create
    @process_flow = ProcessFlow.new(process_flow_params)

    respond_to do |format|
      @process_flow.attachment.created_by = current_user   
      if @process_flow.save
        format.html { redirect_to process_flows_url, notice: 'Process flow was successfully created.' }
        format.json { render json: @process_flow, status: :created, location: @process_flow }
      else
        format.html { render action: "new" }
        format.json { render json: @process_flow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /process_flows/1
  # PUT /process_flows/1.json
  def update
    respond_to do |format|
      @process_flow.attachment.updated_by = current_user
      if @process_flow.update_attributes(process_flow_params)
        format.html { redirect_to process_flows_url, notice: 'Process flow was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @process_flow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_flows/1
  # DELETE /process_flows/1.json
  def destroy
    @process_flow.destroy

    respond_to do |format|
      format.html { redirect_to process_flows_url }
      format.json { head :no_content }
    end
  end

  private

    def set_process_flow
      @process_flow = ProcessFlow.find(params[:id])
    end

    def process_flow_params
      params.require(:process_flow).permit(:process_active, :process_created_id, :process_description, 
                                           :process_identifier, :process_name, :process_notes, :process_updated_id, :attachment_attributes)
    end
end
