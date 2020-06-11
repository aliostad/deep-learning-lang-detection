class Manage::RolesController < ManageController
  before_action :set_manage_role, only: [:show, :edit, :update, :destroy]

  # GET /manage/roles
  # GET /manage/roles.json
  def index
    @manage_roles = Manage::Role.all
  end

  # GET /manage/roles/1
  # GET /manage/roles/1.json
  def show
  end

  # GET /manage/roles/new
  def new
    @manage_role = Manage::Role.new
  end

  # GET /manage/roles/1/edit
  def edit
  end

  # POST /manage/roles
  # POST /manage/roles.json
  def create
    @manage_role = Manage::Role.new(manage_role_params)

    respond_to do |format|
      if @manage_role.save
        format.html { redirect_to @manage_role, notice: 'Role was successfully created.' }
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
        format.html { redirect_to manage_roles_url, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_role }
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
      format.html { redirect_to manage_roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_role
      @manage_role = Manage::Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_role_params
      params.require(:manage_role).permit(:name, :is_enabled, :remark)
    end
end
