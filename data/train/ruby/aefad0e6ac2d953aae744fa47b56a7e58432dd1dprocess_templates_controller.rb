class ProcessTemplatesController < ApplicationController
  include ProcessTemplatesHelper
  before_action :set_process_template, only: [:show, :edit, :update, :destroy]
  before_action :permit_new_process_type, only: [:new, :create]
  # GET /process_templates
  # GET /process_templates.json
  def index
    @process_templates = ProcessTemplate.paginate(:page => params[:page])
  end

  # GET /process_templates/1
  # GET /process_templates/1.json
  def show
  end

  # GET /process_templates/new
  def new
    @process_template = ProcessTemplate.new
    # authorize(@process_template)
  end

  # GET /process_templates/1/edit
  def edit
  end

  # POST /process_templates
  # POST /process_templates.json
  def create
    # authorize(ProcessTemplate)
    params.permit!
    ProcessTemplate.transaction do
      @process_template=ProcessTemplate.new(params[:process_template])
      if ProcessType.auto?(params[:type])
        unless params[:custom_field].blank?
          ProcessTemplateAuto.build_custom_fields(params[:custom_field].keys, @process_template).each do |cf|
            # cf.save
            @process_template.custom_fields<<cf
          end
        end
      elsif ProcessType.semi_auto?(params[:type])
      end
      respond_to do |format|
        if @process_template.save
          format.html { redirect_to @process_template, notice: 'Process template was successfully created.' }
          format.json { render :show, status: :created, location: @process_template }
        else
          format.html { render :new }
          format.json { render json: @process_template.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # PATCH/PUT /process_templates/1
  # PATCH/PUT /process_templates/1.json
  def update
    respond_to do |format|
      if @process_template.update(process_template_params)
        format.html { redirect_to @process_template, notice: 'Process template was successfully updated.' }
        format.json { render :show, status: :ok, location: @process_template }
      else
        format.html { render :edit }
        format.json { render json: @process_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_templates/1
  # DELETE /process_templates/1.json
  def destroy
    @process_template.destroy
    respond_to do |format|
      format.html { redirect_to process_templates_url, notice: 'Process template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def template
    # authorize(ProcessTemplate)
    if @process_template=ProcessTemplate.find_by_code(params[:code])
      if ProcessType.auto?(@process_template.type)
        render partial: 'new_process_auto'
      elsif ProcessType.semi_auto?(@process_template.type)
        render partial: 'new_process_semi_auto'
      end
    else
      render partial: 'shared/messages/no_found'
    end
  end

  def import
    # authorize(ProcessTemplate)
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file,original_name:file.original_filename,path:$upload_data_file_path,path_name:"#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        file=FileHandler::Csv::File.new(user_agent: request.user_agent.downcase,file_path: fd.full_path,file_name: file.original_filename)
        msg = FileHandler::Csv::ProcessTemplateHandler.import(file)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end


  def autoimport
    # authorize(ProcessTemplate)
    ProcessTemplate.import(params[:file], 'auto')
    redirect_to process_templates_url, notice: 'ProcessTemplate was successfully imported.'
  end
  
  def semiautoimport
    # authorize(ProcessTemplate)
  end 
  
  def manual_import
    # authorize(ProcessTemplate)
    ProcessTemplate.import(params[:file], 'manual')
    redirect_to process_templates_url, notice: 'ProcessTemplate was successfully imported.'
  end
  


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_process_template
    @process_template = ProcessTemplate.find(params[:id])
    # authorize(@process_template)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def process_template_params
    #params.permit!
    params.require(:process_template).permit! #(:code, :type, :name, :template, :description)
  end

  def permit_new_process_type
    @process_type=params[:type]
    if @process_type.blank?
      render action: 'select_type'
    end
  end
end
