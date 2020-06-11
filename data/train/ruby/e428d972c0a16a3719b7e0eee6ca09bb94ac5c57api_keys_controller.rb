class ApiKeysController < ApplicationController
  before_filter :check_admin_mode, :only => [:index, :destroy]

  def check_admin_mode
    unless false #i'm a hacky hacky switch!
      redirect_to :back 
    end
  end

  # GET /api_keys
  # GET /api_keys.xml
  def index
    @api_keys = ApiKey.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @api_keys }
    end
  end

  # GET /api_keys/1
  # GET /api_keys/1.xml
  def show
    @api_key = ApiKey.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @api_key }
    end
  end

  # GET /api_keys/new
  # GET /api_keys/new.xml
  def new
    @api_key = ApiKey.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @api_key }
    end
  end

  # POST /api_keys
  # POST /api_keys.xml
  def create
    @api_key = ApiKey.new(params[:api_key])
    @api_key.key = Digest::SHA1.hexdigest params[:api_key][:username]

    respond_to do |format|
      if @api_key.save
        flash[:notice] = 'ApiKey was successfully created.'
        format.html { redirect_to(@api_key) }
        format.xml  { render :xml => @api_key, :status => :created, :location => @api_key }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @api_key.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /api_keys/1
  # PUT /api_keys/1.xml
  def update
    @api_key = ApiKey.find(params[:id])

    respond_to do |format|
      if @api_key.update_attributes(params[:api_key])
        flash[:notice] = 'ApiKey was successfully updated.'
        format.html { redirect_to(@api_key) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @api_key.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /api_keys/1
  # DELETE /api_keys/1.xml
  def destroy
    @api_key = ApiKey.find(params[:id])
    @api_key.destroy

    respond_to do |format|
      format.html { redirect_to(api_keys_url) }
      format.xml  { head :ok }
    end
  end
end
