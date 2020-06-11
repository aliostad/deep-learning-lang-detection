class KanbanProcessEntitiesController < ApplicationController
  before_action :set_kanban_process_entity, only: [:show, :edit, :update, :destroy]

  # GET /kanban_process_entities
  # GET /kanban_process_entities.json
  def index
    @kanban_process_entities = KanbanProcessEntity.all
  end

  # GET /kanban_process_entities/1
  # GET /kanban_process_entities/1.json
  def show
  end

  # GET /kanban_process_entities/new
  def new
    @kanban_process_entity = KanbanProcessEntity.new
  end

  # GET /kanban_process_entities/1/edit
  def edit
  end

  # POST /kanban_process_entities
  # POST /kanban_process_entities.json
  def create
    @kanban_process_entity = KanbanProcessEntity.new(kanban_process_entity_params)

    respond_to do |format|
      if @kanban_process_entity.save
        format.html { redirect_to @kanban_process_entity, notice: 'Kanban process entity was successfully created.' }
        format.json { render :show, status: :created, location: @kanban_process_entity }
      else
        format.html { render :new }
        format.json { render json: @kanban_process_entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kanban_process_entities/1
  # PATCH/PUT /kanban_process_entities/1.json
  def update
    respond_to do |format|
      if @kanban_process_entity.update(kanban_process_entity_params)
        format.html { redirect_to @kanban_process_entity, notice: 'Kanban process entity was successfully updated.' }
        format.json { respond_with_bip(@kanban_process_entity) }
      else
        format.html { render :edit }
        format.json { respond_with_bip(@kanban_process_entity) }
      end
    end
  end

  # DELETE /kanban_process_entities/1
  # DELETE /kanban_process_entities/1.json
  def destroy
    @kanban_process_entity.destroy
    respond_to do |format|
      format.html { redirect_to kanban_process_entities_url, notice: 'Kanban process entity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kanban_process_entity
      @kanban_process_entity = KanbanProcessEntity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kanban_process_entity_params
      params.require(:kanban_process_entity).permit(:kanban_id, :process_entity_id,:position)
    end
end
