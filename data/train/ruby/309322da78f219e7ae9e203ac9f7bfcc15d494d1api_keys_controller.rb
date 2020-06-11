class ApiKeysController < ApplicationController
  before_filter :login_required
  before_filter :find_api_key_user

  # GET /api_keys
  # GET /api_keys.xml
  def index
    @api_keys = @user.api_keys.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @api_keys }
    end
  end

  # GET /api_keys/1
  # GET /api_keys/1.xml
  def show
    @api_key = @user.api_keys.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @api_key }
    end
  end

  # GET /api_keys/new
  # GET /api_keys/new.xml
  def new
    @api_key = @user.api_keys.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @api_key }
    end
  end

  # POST /api_keys
  # POST /api_keys.xml
  def create
    @api_key = @user.api_keys.build(params[:api_key])

    respond_to do |format|
      if @api_key.save
        flash[:notice] = 'ApiKey was successfully created.'
        format.html { redirect_to(user_api_keys_path) }
        format.xml  { render :xml => @api_key, :status => :created, :location => @api_key }
      else
        format.html { render :action => "new" }
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
      format.html { redirect_to(user_api_keys_path) }
      format.xml  { head :ok }
    end
  end
  
  private
  def find_api_key_user
    @user = current_user
  end
end
