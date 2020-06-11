class ProcessTrunksController < ApplicationController

  verify :session => :admin,
    :add_flash => {:error => "You are not signed in as 'admin' "},
    :redirect_to => {:controller => "authentication", :action => "login"},
    :except => [:show, :create, :edit, :update]

  before_filter :find_process_trunk, :only => [:edit, :update, :show, :destroy]

  def find_process_trunk
    @process_trunk = ProcessTrunk.find(params[:id])
  end

  # GET /process_trunks
  # GET /process_trunks.xml
  def index
    @process_trunks = ProcessTrunk.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @process_trunks }
    end
  end

  # GET /process_trunks/1
  # GET /process_trunks/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @process_trunk }
    end
  end

  # GET /process_trunks/new
  # GET /process_trunks/new.xml
  def new
    @process_trunk = ProcessTrunk.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @process_trunk }
    end
  end

  # GET /process_trunks/1/edit
  def edit
    @trunk = @process_trunk.trunk
  end

  # POST /process_trunks
  # POST /process_trunks.xml
  def create
    @process_trunk = ProcessTrunk.new(params[:process_trunk])

    respond_to do |format|
      if @process_trunk.save
        flash[:notice] = 'ProcessTrunk was successfully created.'
        format.html { redirect_to :back }
        format.xml  { render :xml => @process_trunk, :status => :created, :location => @process_trunk }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @process_trunk.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /process_trunks/1
  # PUT /process_trunks/1.xml
  def update

    respond_to do |format|
      if @process_trunk.update_attributes(params[:process_trunk])
        flash[:notice] = 'ProcessTrunk was successfully updated.'
        format.html { redirect_to(@process_trunk) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @process_trunk.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /process_trunks/1
  # DELETE /process_trunks/1.xml
  def destroy
    @process_trunk.destroy

    respond_to do |format|
      format.html { redirect_to :back}
      # format.html { redirect_to(process_trunks_url) }
      format.xml  { head :ok }
    end
  end
end
