class Manage::RolesController < ManageController
  before_action :set_manage_role, only: [:show, :edit, :update, :destroy]
  before_action :set_nodes, only: [:new, :edit, :update, :show, :create]

  # GET /manage/roles
  # GET /manage/roles.json
  def index
    @manage_roles = Manage::Role.all
  end

  # GET /manage/roles/1
  # GET /manage/roles/1.json
  def show
    @role_nodes= Manage::Role.find(params[:id]).nodes
  end

  # GET /manage/roles/new
  def new
    @manage_role = Manage::Role.new
  end

  # GET /manage/roles/1/edit
  def edit
    @role_nodes= Manage::Role.find(params[:id]).nodes
  end

  # POST /manage/roles
  # POST /manage/roles.json
  def create
    @manage_role = Manage::Role.new(manage_role_params)

    respond_to do |format|
      if @manage_role.save

        # 保存角色信息
        nodes_id=params[:nodes]
        @manage_role.nodes_in_id=nodes_id  

        format.html { redirect_to @manage_role, notice: "成功创建角色#{@manage_role.name}" }
        format.json { render :show, status: :created, location: @manage_role }
      else
        format.html { render :new }
        format.json { render json: @manage_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/roles/1
  # PATCH/PUT /manage/roles/1.json
  def update
    respond_to do |format|
      if @manage_role.update(manage_role_params)

        # 保存角色信息
        nodes_id=params[:nodes]
        @manage_role.nodes_in_id=nodes_id

        format.html { redirect_to @manage_role, notice: "成功修改角色#{@manage_role.name}" }
        format.json { render :show, status: :created, location: @manage_role }

      else
        format.html { render :edit }
        format.json { render json: @manage_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/roles/1
  # DELETE /manage/roles/1.json
  def destroy
    @manage_role.destroy
    respond_to do |format|
      format.html { redirect_to manage_roles_url, notice: '成功删除角色' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_role
      @manage_role = Manage::Role.find(params[:id])
    end

    def set_nodes
      @manage_nodes = Manage::Node.tree_view
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_role_params
      params.require(:manage_role).permit(:name, :is_enabled, :remark)
    end
end
