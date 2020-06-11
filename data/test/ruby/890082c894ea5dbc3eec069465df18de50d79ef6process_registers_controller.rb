class ProcessRegistersController < ApplicationController  
  before_filter :authenticate_user!
  #load_and_authorize_resource
  
  # GET /process_registers
  # GET /process_registers.xml
  def index
    if current_user.profile == "Atendedor"
      @process_registers = ProcessRegister.search(params[:search]).incorrect_closed.paginate(:page => params[:page], :per_page => 10, :order => :id, :include =>[:proprietary, :vehicle])
    elsif current_user.profile == "Analista"
      @process_registers = ProcessRegister.search(params[:search]).opened_aproved_reproved.paginate(:page => params[:page], :per_page => 10, :order => :id, :include =>[:proprietary, :vehicle])
    elsif current_user.profile == "Conservador"
      @process_registers = ProcessRegister.search(params[:search]).correct.paginate(:page => params[:page], :per_page => 10, :order => :id, :include =>[:proprietary, :vehicle])
    else
      @process_registers = ProcessRegister.search(params[:search]).paginate(:page => params[:page], :per_page => 10, :order => :id, :include =>[:proprietary, :vehicle])
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @process_registers }
      format.js
    end
  end

  # GET /process_registers/1
  # GET /process_registers/1.xml
  def show
    @process_register = ProcessRegister.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @process_register }
      format.pdf
    end
  end

  # GET /process_registers/new
  # GET /process_registers/new.xml
  def new
    @process_register = ProcessRegister.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @process_register }
    end
  end

  # GET /process_registers/1/edit
  def edit
    @process_register = ProcessRegister.find(params[:id])
  end

  # POST /process_registers
  # POST /process_registers.xml
  def create
    @process_register = ProcessRegister.new(params[:process_register])

    respond_to do |format|
      if @process_register.save
        format.html { redirect_to(@process_register, :notice => 'Process register was successfully created.') }
        format.xml  { render :xml => @process_register, :status => :created, :location => @process_register }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @process_register.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /process_registers/1
  # PUT /process_registers/1.xml
  
  def update
    @process_register = ProcessRegister.find(params[:id])

    respond_to do |format|
      if @process_register.update_attributes(params[:process_register])
        format.html { redirect_to(@process_register, :notice => 'Process register was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @process_register.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /process_registers/1
  # DELETE /process_registers/1.xml
  def destroy
    @process_register = ProcessRegister.find(params[:id])
    @process_register.destroy

    respond_to do |format|
      format.html { redirect_to(process_registers_url) }
      format.xml  { head :ok }
    end
  end
  
  # Actualizar o campo devivery_status
  def delivery_status
    @process_register = ProcessRegister.find(params[:id])
    if @process_register.update_attributes(:delivery_status =>true)
        redirect_to(@process_register, :notice => 'Processo de Entrega Executado com Sucesso')
    end  
  end
  
end
