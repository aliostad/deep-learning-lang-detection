class Manage::ProfessionsController < ManageController
  before_action :set_manage_profession, only: [:show, :edit, :update, :destroy]
  before_action :set_profession_list, only: [:index, :create]

  # GET /manage/professions
  # GET /manage/professions.json
  def index
    @new_college = Manage::Profession.new
  end


  # GET /manage/professions/1/edit
  def edit
  end

  # POST /manage/professions
  # POST /manage/professions.json
  def create
    @new_college = Manage::Profession.new(manage_profession_params)

    respond_to do |format|
      if @new_college.save
        format.html { redirect_to manage_professions_url, notice: '创建成功' }
        format.json { render :show, status: :created, location: @new_college }
      else
        format.html { render :index }
        format.json { render json: @new_college.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/professions/1
  # PATCH/PUT /manage/professions/1.json
  def update
    respond_to do |format|
      if @manage_profession.update(manage_profession_params)
        format.html { redirect_to manage_professions_url, notice: '更新成功' }
        format.json { render :show, status: :ok, location: @manage_profession }
      else
        @pid=manage_profession_params[:pid]
        format.html { render :edit }
        format.json { render json: @manage_profession.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/professions/1
  # DELETE /manage/professions/1.json
  def destroy
    if @manage_profession.destroy
      notice='学院/专业已被删除'
    else
      notice='删除失败，专业不为空'
    end
    respond_to do |format|
      format.html { redirect_to manage_professions_url, notice: notice }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_profession
      @manage_profession = Manage::Profession.find(params[:id])
    end

    def set_profession_list
      @manage_professions = Manage::Profession.tree_view
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_profession_params
      params.require(:manage_profession).permit(:name, :pid)
    end
end
