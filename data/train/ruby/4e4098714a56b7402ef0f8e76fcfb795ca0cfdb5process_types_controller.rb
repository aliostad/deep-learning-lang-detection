class ProcessTypesController < ApplicationController
  # GET /process_types
  # GET /process_types.xml
  def index
    @process_types = ProcessType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @process_types }
    end
  end

  # GET /process_types/1
  # GET /process_types/1.xml
  def show
    @process_type = ProcessType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @process_type }
    end
  end

  # GET /process_types/new
  # GET /process_types/new.xml
  def new
    @process_type = ProcessType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @process_type }
    end
  end

  # GET /process_types/1/edit
  def edit
    @process_type = ProcessType.find(params[:id])
  end

  # POST /process_types
  # POST /process_types.xml
  def create
    @process_type = ProcessType.new(params[:process_type])

    respond_to do |format|
      if @process_type.save
        format.html { redirect_to(@process_type, :notice => 'Process type was successfully created.') }
        format.xml  { render :xml => @process_type, :status => :created, :location => @process_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @process_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /process_types/1
  # PUT /process_types/1.xml
  def update
    @process_type = ProcessType.find(params[:id])

    respond_to do |format|
      if @process_type.update_attributes(params[:process_type])
        format.html { redirect_to(@process_type, :notice => 'Process type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @process_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /process_types/1
  # DELETE /process_types/1.xml
  def destroy
    @process_type = ProcessType.find(params[:id])
    @process_type.destroy

    respond_to do |format|
      format.html { redirect_to(process_types_url) }
      format.xml  { head :ok }
    end
  end
end
