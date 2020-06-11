class Manage::NodesController < ManageController
  before_action :set_manage_node, only: [:show, :edit, :update, :destroy]

  # GET /manage/nodes
  # GET /manage/nodes.json
  def index
    @manage_nodes = Manage::Node.all
  end

  # GET /manage/nodes/1
  # GET /manage/nodes/1.json
  def show
  end

  # GET /manage/nodes/new
  def new
    @manage_node = Manage::Node.new
  end

  # GET /manage/nodes/1/edit
  def edit
  end

  # POST /manage/nodes
  # POST /manage/nodes.json
  def create
    @manage_node = Manage::Node.new(manage_node_params)

    respond_to do |format|
      if @manage_node.save
        format.html { redirect_to @manage_node, notice: 'Node was successfully created.' }
        format.json { render :show, status: :created, location: @manage_node }
      else
        format.html { render :new }
        format.json { render json: @manage_node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/nodes/1
  # PATCH/PUT /manage/nodes/1.json
  def update
    respond_to do |format|
      if @manage_node.update(manage_node_params)
        format.html { redirect_to @manage_node, notice: 'Node was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_node }
      else
        format.html { render :edit }
        format.json { render json: @manage_node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/nodes/1
  # DELETE /manage/nodes/1.json
  def destroy
    @manage_node.destroy
    respond_to do |format|
      format.html { redirect_to manage_nodes_url, notice: 'Node was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_node
      @manage_node = Manage::Node.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_node_params
      params.require(:manage_node).permit(:name, :title, :remark, :extra_data, :sort, :pid)
    end
end
