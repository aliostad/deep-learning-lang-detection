class Manage::AdminsController < ManageController
  before_action :set_manage_admin, only: [:show, :edit, :update, :destroy]
  before_action :set_roles, only: [:edit, :update, :create]

  # GET /manage/admins
  # GET /manage/admins.json
  def index
  	@total_count = Manage::Admin.count()
  	offset = params[:start]
  	limit = params[:limit]
    query = '%' + params[:query].to_s + '%'
    @manage_admins = Manage::Admin.where("uid like ? or nickname like ?",query,query).limit(limit).offset(offset)
  end

  def show
    @manage_nodes= Manage::Node.tree_view
    @admin_privileges_names = @manage_admin.child_nodes.collect{|x| x.name}
    @admin_privileges_tree = @manage_admin.tree_view_of_nodes
  end

  # GET /manage/admins/1/edit
  def edit
    @admin_roles= Manage::Admin.find(params[:id]).roles
  end
  # POST /manage/admins
  # POST /manage/admins.json
  def create
    @manage_admin = Manage::Admin.new(manage_admin_params)
    @admin_roles= @manage_admin.roles
    respond_to do |format|
      if @manage_admin.save

        # 保存角色信息
        roles_id=params[:roles]
        @manage_admin.roles_in_id=roles_id

        format.html { redirect_to @manage_admin, notice: "成功创建管理员#{@manage_admin.nickname}." }

        format.json { render :show, status: :created, location: @manage_admin }
      else
        format.html { render :new }
        format.json { render json: @manage_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/admins/1
  # PATCH/PUT /manage/admins/1.json
  def update
    respond_to do |format|
      if @manage_admin.update(manage_admin_params)

        # 保存角色信息
        roles_id=params[:roles]
        @manage_admin.roles_in_id=roles_id

        format.html { redirect_to @manage_admin, notice: '管理员信息更新成功.' }

        format.json { render :show, status: :ok, location: @manage_admin }
      else
        format.html { render :edit,notice:'修改失败'}
        format.json { render json: @manage_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/admins/1
  # DELETE /manage/admins/1.json
  def destroy
    @manage_admin.destroy
    respond_to do |format|

      format.html { redirect_to manage_admins_url, notice: '此管理员账户已被删除.' }

      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_admin
      @manage_admin = Manage::Admin.find(params[:id])
    end

    def set_roles
      @manage_roles=Manage::Role.all
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_admin_params
      params.require(:manage_admin).permit(:uid, :nickname, :pwd, :email, :desc, :is_enabled)
    end
end
