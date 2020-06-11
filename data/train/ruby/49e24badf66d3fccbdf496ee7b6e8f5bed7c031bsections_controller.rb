class Manage::SectionsController < ManageController
  before_action :set_manage_section, only: [:show, :edit, :update, :destroy]
  before_action :set_compete_id,except: [:xform_render]

  # GET /manage/sections/1
  # GET /manage/sections/1.json
  def show
  end

  # GET /manage/sections/new
  def new
    @manage_section = Manage::Section.new
  end

  # GET /manage/sections/1/edit
  def edit
    @xforms = @manage_section.xforms
  end

  # POST /manage/sections
  # POST /manage/sections.json
  def create
    @manage_section = Manage::Section.new(manage_section_params)

    respond_to do |format|
      if @manage_section.save
        format.html { redirect_to manage_compete_url(@compete), notice: 'Section was successfully created.' }
        format.json { render :show, status: :created, location: @manage_section }
      else
        format.html { render :new }
        format.json { render json: @manage_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/sections/1
  # PATCH/PUT /manage/sections/1.json
  def update
    # render json:params
    # return 


    respond_to do |format|
      if @manage_section.update(manage_section_params)
        format.html { redirect_to manage_compete_url(@compete), notice: 'Section was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_section }
      else
        format.html { render :edit }
        format.json { render json: @manage_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/sections/1
  # DELETE /manage/sections/1.json
  def destroy
    @manage_section.destroy
    respond_to do |format|
      format.html { redirect_to manage_compete_url(@compete), notice: 'Section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_section
      @manage_section = Manage::Section.find(params[:id])
    end

    def set_compete_id
      @compete = Manage::Compete.find(params[:compete_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_section_params
      param = params.require(:manage_section).permit(:name, :end_time)
      param[:compete_id]=@compete.id
      param
    end
end
