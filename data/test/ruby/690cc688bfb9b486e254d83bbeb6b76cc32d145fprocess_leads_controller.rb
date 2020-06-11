class ProcessLeadsController < ApplicationController
  authorize_resource
  #before_filter :authenticate_user!
  before_action :set_process_lead, only: [:show, :edit, :update, :destroy]
  #skip_before_filter :authenticate_user!, only: [:create]
  skip_before_filter :verify_authenticity_token, :only => [:create]

  # GET /process_leads
  # GET /process_leads.json
  def index
    @process_leads = ProcessLead.all
  end

  # GET /process_leads/1
  # GET /process_leads/1.json
  def show
  end

  # GET /process_leads/new
  def new
    @process_lead = ProcessLead.new
  end

  # GET /process_leads/1/edit
  def edit
  end

  # POST /process_leads
  # POST /process_leads.json
  def create
    @process_lead = ProcessLead.new(process_lead_params)
    if @process_lead.save
      ACCMailer.process_lead_mail(@process_lead).deliver
      @success = true
      @message = "Hemos recibido tu solicitud de trámite. En breve nos pondremos en contacto contigo."
      #format.html { redirect_to @process_lead, notice: 'ProcessLead was successfully created.' }
      #format.json { render :show, status: :created, location: @process_lead }
    else
      @success = false
      @message = "Ocurrió un error con tu solicitud de trámite. Favor intentar nuevamente."
      #format.html { render :new }
      #format.json { render json: @process_lead.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /process_leads/1
  # PATCH/PUT /process_leads/1.json
  def update
    respond_to do |format|
      if @process_lead.update(process_lead_params)
        format.html { redirect_to @process_lead, notice: 'ProcessLead was successfully updated.' }
        format.json { render :show, status: :ok, location: @process_lead }
      else
        format.html { render :edit }
        format.json { render json: @process_lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_leads/1
  # DELETE /process_leads/1.json
  def destroy
    @process_lead.destroy
    respond_to do |format|
      format.html { redirect_to leads_url, notice: 'ProcessLead was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_lead
      @process_lead = ProcessLead.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def process_lead_params
      params.require(:process_lead).permit(:first_name, :last_name_f, :last_name_m, :phone_number, :email, :process_type, :other_type)
    end
end


