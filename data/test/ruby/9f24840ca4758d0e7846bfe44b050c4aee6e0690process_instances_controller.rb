class Pluto::ProcessInstancesController < ApplicationController
  # GET /pluto/process_instances
  # GET /pluto/process_instances.json
  def index
    @pluto_process_instances = Pluto::ProcessInstance.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pluto_process_instances }
    end
  end

  # GET /pluto/process_instances/1
  # GET /pluto/process_instances/1.json
  def show
    @pluto_process_instance = Pluto::ProcessInstance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pluto_process_instance }
    end
  end

  # GET /pluto/process_instances/new
  # GET /pluto/process_instances/new.json
  def new
    @pluto_process_instance = Pluto::ProcessInstance.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pluto_process_instance }
    end
  end

  # GET /pluto/process_instances/1/edit
  def edit
    @pluto_process_instance = Pluto::ProcessInstance.find(params[:id])
  end

  # POST /pluto/process_instances
  # POST /pluto/process_instances.json
  def create
    @pluto_process_instance = Pluto::ProcessInstance.new(params[:pluto_process_instance])

    respond_to do |format|
      if @pluto_process_instance.save
        format.html do
          flash[:success] = 'Process instance was successfully created.'
          redirect_to @pluto_process_instance
        end
        format.json { render json: @pluto_process_instance, status: :created, location: @pluto_process_instance }
      else
        format.html { render action: "new" }
        format.json { render json: @pluto_process_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pluto/process_instances/1
  # PUT /pluto/process_instances/1.json
  def update
    @pluto_process_instance = Pluto::ProcessInstance.find(params[:id])

    respond_to do |format|
      if @pluto_process_instance.update_attributes(params[:pluto_process_instance])
        format.html do
          flash[:success] = 'Process instance was successfully updated.'
          redirect_to @pluto_process_instance
        end
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @pluto_process_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pluto/process_instances/1
  # DELETE /pluto/process_instances/1.json
  def destroy
    @pluto_process_instance = Pluto::ProcessInstance.find(params[:id])
    @pluto_process_instance.destroy

    respond_to do |format|
      format.html { redirect_to pluto_process_instances_url }
      format.json { head :ok }
    end
  end
end
