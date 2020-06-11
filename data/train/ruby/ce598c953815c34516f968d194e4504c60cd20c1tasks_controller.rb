class Api::TasksController < ApiController
  # GET /api/tasks
  # GET /api/tasks.json
  def index
    @api_tasks = Task.all

    render json: @api_tasks
  end

  # GET /api/tasks/1
  # GET /api/tasks/1.json
  def show
    @api_task = Task.find(params[:id])

    render json: @api_task
  end

  # POST /api/tasks
  # POST /api/tasks.json
  def create
    @api_task = Task.new(params[:api_task])

    if @api_task.save
      render json: @api_task, status: :created
    else
      render json: @api_task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/tasks/1
  # PATCH/PUT /api/tasks/1.json
  def update
    @api_task = Task.find(params[:id])

    if @api_task.update(params[:api_task])
      head :no_content
    else
      render json: @api_task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/tasks/1
  # DELETE /api/tasks/1.json
  def destroy
    @api_task = Task.find(params[:id])
    @api_task.destroy

    head :no_content
  end
end
