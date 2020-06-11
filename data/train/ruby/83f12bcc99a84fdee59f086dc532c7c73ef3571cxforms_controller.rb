class Manage::XformsController < ManageController
  before_action :set_manage_xform, only: [:show, :edit, :update, :destroy]
  before_action :set_parent_objs

  # GET /manage/xforms/1
  # GET /manage/xforms/1.json
  def show
  end

  # GET /manage/xforms/new
  def new
    @manage_xform = Manage::Xform.new
    @field_type = params[:field_type]
  end

  # GET /manage/xforms/1/edit
  def edit
    @field_type = @manage_xform.field_type
  end

  # POST /manage/xforms
  # POST /manage/xforms.json
  def create
    @manage_xform = Manage::Xform.new(manage_xform_params)

    respond_to do |format|
      if @manage_xform.save
        format.html { redirect_to edit_manage_compete_section_path(@compete,@section) }
        format.json { render json:{code:"OK"}, status: :ok }
        flash[:notice]="已添加#{@manage_xform.name}字段，其类型为：#{@manage_xform.field_type}"
      else
        format.html { render :new }
        format.json { render json: @manage_xform.errors.full_messages, status: :unprocessable_entity }
      end
    end

    # if @manage_xform.save
    #   redirect_to @manage_xform, notice: '已添加'
    # else
    #   render :new
    # end
  end

  # PATCH/PUT /manage/xforms/1
  # PATCH/PUT /manage/xforms/1.json
  def update
    respond_to do |format|
      if @manage_xform.update(manage_xform_params)
        format.html { redirect_to edit_manage_compete_section_path(@compete,@section) }
        format.json { render json:{code:"OK"}, status: :ok }
        flash[:notice]="已更改#{@manage_xform.name}字段"
      else
        format.html { render :edit }
        format.json { render json: @manage_xform.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/xforms/1
  # DELETE /manage/xforms/1.json
  def destroy
    @manage_xform.destroy
    respond_to do |format|
      format.html { redirect_to manage_xforms_url, notice: 'Xform was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_xform
      @manage_xform = Manage::Xform.find(params[:id])
      
    end

    def set_parent_objs
      @section = Manage::Section.find(params[:section_id])
      @compete = Manage::Compete.find(params[:compete_id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_xform_params
      param = params.require(:manage_xform).permit(:name,:field_type,:default_val,:length_limit,:message,:sort   , :value_range_from, :value_range_to)
      param.merge({section_id: params[:section_id]})
    end
end
