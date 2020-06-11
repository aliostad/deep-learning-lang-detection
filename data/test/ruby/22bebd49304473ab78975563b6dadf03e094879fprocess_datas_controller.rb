class ProcessDatasController < ApplicationController
  # GET /process_datas
  # GET /process_datas.xml
  def index
    @process_datas = ProcessData.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @process_datas }
    end
  end

  # GET /process_datas/1
  # GET /process_datas/1.xml
  def show
    @process_data = ProcessData.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @process_data }
    end
  end

  # GET /process_datas/new
  # GET /process_datas/new.xml
  def new
    @process_data = ProcessData.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @process_data }
    end
  end

  # GET /process_datas/1/edit
  def edit
    @process_data = ProcessData.find(params[:id])
  end

  # POST /process_datas
  # POST /process_datas.xml
  def create
    @process_data = ProcessData.new(params[:process_data])
    @product = Product.find(params[:product_id])
    @process_data.product = @product
    
    respond_to do |format|
      if @process_data.save
        format.js  { render :action => "create_process" }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @process_data.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /process_datas/1
  # PUT /process_datas/1.xml
  def update
    @process_data = ProcessData.find(params[:id])

    respond_to do |format|
      if @process_data.update_attributes(params[:process_data])
        format.html { redirect_to(@process_data, :notice => 'Process data was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @process_data.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /process_datas/1
  # DELETE /process_datas/1.xml
  def destroy
    @process_data = ProcessData.find(params[:id])
    @process_data.destroy

    respond_to do |format|
      format.js  { render :action => "destroy_process" }
    end
  end
end
