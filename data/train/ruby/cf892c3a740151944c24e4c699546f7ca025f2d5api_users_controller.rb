class V1::ApiUsersController < ApplicationController
  # GET /v1_api_users
  # GET /v1_api_users.xml
  def index
    @v1_api_users = V1::ApiUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @v1_api_users }
    end
  end

  # GET /v1_api_users/1
  # GET /v1_api_users/1.xml
  def show
    @api_user = V1::ApiUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @api_user }
    end
  end

  # GET /v1_api_users/new
  # GET /v1_api_users/new.xml
  def new
    @api_user = V1::ApiUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @api_user }
    end
  end

  # GET /v1_api_users/1/edit
  def edit
    @api_user = V1::ApiUser.find(params[:id])
  end

  # POST /v1_api_users
  # POST /v1_api_users.xml
  def create
    @api_user = V1::ApiUser.new(params[:api_user])

    respond_to do |format|
      if @api_user.save
        flash[:notice] = 'V1::ApiUser was successfully created.'
        format.html { redirect_to(@api_user) }
        format.xml  { render :xml => @api_user, :status => :created, :location => @api_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @api_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /v1_api_users/1
  # PUT /v1_api_users/1.xml
  def update
    @api_user = V1::ApiUser.find(params[:id])

    respond_to do |format|
      if @api_user.update_attributes(params[:api_user])
        flash[:notice] = 'V1::ApiUser was successfully updated.'
        format.html { redirect_to(@api_user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @api_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /v1_api_users/1
  # DELETE /v1_api_users/1.xml
  def destroy
    @api_user = V1::ApiUser.find(params[:id])
    @api_user.destroy

    respond_to do |format|
      format.html { redirect_to(v1_api_users_url) }
      format.xml  { head :ok }
    end
  end
end
