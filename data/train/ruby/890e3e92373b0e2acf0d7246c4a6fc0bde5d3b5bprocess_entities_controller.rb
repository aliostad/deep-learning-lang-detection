class ProcessEntitiesController < ApplicationController
  before_filter :select_tab

  def index
    if @service_system.present?
      @process_entities = ProcessEntity.where "service_system_id = ?", @service_system.id
    else
      @process_entities = ProcessEntity.all
    end

    respond_to do |format|
      format.html
      format.json { render json: @process_entities }
    end
  end

  def show
    @process_entity = ProcessEntity.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @process_entity }
    end
  end

  def new
    @process_entity = @service_system.process_entities.build

    respond_to do |format|
      format.html
      format.json { render json: @process_entity }
    end
  end

  def edit
    @process_entity = ProcessEntity.find(params[:id])
  end

  def create
    @process_entity = ProcessEntity.new(params[:process_entity])
    @process_entity.sid = camel_case @process_entity.label
    @process_entity.service_system = @service_system if @service_system.present?

    respond_to do |format|
      if @process_entity.save
        format.html { redirect_to service_system_process_entities_url, notice: 'Process was successfully created.' }
        format.json { render json: @process_entity, status: :created, location: @process_entity }
      else
        format.html { render action: "new" }
        format.json { render json: @process_entity.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @process_entity = ProcessEntity.find(params[:id])
    params[:process_entity][:sid] = camel_case params[:process_entity][:label]

    respond_to do |format|
      if @process_entity.update_attributes(params[:process_entity])
        format.html { redirect_to service_system_process_entity_url, notice: 'Process was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @process_entity.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @process_entity = ProcessEntity.find(params[:id])
    @process_entity.destroy

    respond_to do |format|
      format.html { redirect_to service_system_process_entities_url }
      format.json { head :no_content }
    end
  end

  private

  def select_tab
    @tab = {"processes" => true}
  end
end
