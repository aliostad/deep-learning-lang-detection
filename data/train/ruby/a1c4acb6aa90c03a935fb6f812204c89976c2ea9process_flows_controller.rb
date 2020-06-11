class ProcessFlowsController < ApplicationController
  # GET /process_flows
  # GET /process_flows.xml
  def index
    @process_flows = ProcessFlow.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @process_flows }
    end
  end

  # GET /process_flows/1
  # GET /process_flows/1.xml
  def show
  	begin
    @process_flow = ProcessFlow.find(params[:id])
    
    #Error handling for bad process_flow_id
   	rescue ActiveRecord::RecordNotFound
   		logger.error "Attempt to access invalid process_flow #{params[:id]}"
   		redirect_to flow_generator_url, :notice => 'Invalid process_flow'
   	else
   		respond_to do |format|
	    	format.html # show.html.erb
	    	format.xml  { render :xml => @process_flow }
    	end
  	end
  end
  # GET /process_flows/new
  # GET /process_flows/new.xml
  def new
    @process_flow = ProcessFlow.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @process_flow }
    end
  end

  # GET /process_flows/1/edit
  def edit
    @process_flow = ProcessFlow.find(params[:id])
  end

  # POST /process_flows
  # POST /process_flows.xml
  def create
    @process_flow = ProcessFlow.new(params[:process_flow])

    respond_to do |format|
      if @process_flow.save
        format.html { redirect_to(@process_flow, :notice => 'Process flow was successfully created.') }
        format.xml  { render :xml => @process_flow, :status => :created, :location => @process_flow }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @process_flow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /process_flows/1
  # PUT /process_flows/1.xml
  def update
    @process_flow = ProcessFlow.find(params[:id])

    respond_to do |format|
      if @process_flow.update_attributes(params[:process_flow])
        format.html { redirect_to(@process_flow, :notice => 'Process flow was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @process_flow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /process_flows/1
  # DELETE /process_flows/1.xml
  def destroy
    @process_flow = ProcessFlow.find(params[:id])
    @process_flow.destroy
    session[:process_flow_id] = nil
    
    respond_to do |format|
      format.html { redirect_to(flow_generator_url, :notice => 'Process flow deleted') }
      format.xml  { head :ok }
    end
  end
end
