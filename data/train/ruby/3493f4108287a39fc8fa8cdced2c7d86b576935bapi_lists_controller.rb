class ApiListsController < ApplicationController
  # GET /api_lists
  # GET /api_lists.xml
  before_filter :authenticate_user!
  def index
    @api_lists = ApiList.all


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @api_lists }
    end
  end

  # GET /api_lists/1
  # GET /api_lists/1.xml
  def show
    @api_list = ApiList.find_by_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @api_list }
    end
  end

  # GET /api_lists/new
  # GET /api_lists/new.xml
  def new
    @api_list = ApiList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @api_list }
    end
  end

  # GET /api_lists/1/edit
  def edit
    @api_list = ApiList.find_by_id(params[:id])
  end

  # POST /api_lists
  # POST /api_lists.xml
  def create
    @api_list = ApiList.new(params[:api_list])

    respond_to do |format|
      if @api_list.save
        format.html { redirect_to(@api_list, :notice => 'Api list was successfully created.') }
        format.xml  { render :xml => @api_list, :status => :created, :location => @api_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @api_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /api_lists/1
  # PUT /api_lists/1.xml
  def update
    @api_list = ApiList.find_by_id(params[:id])

    respond_to do |format|
      if @api_list.update_attributes(params[:api_list])
        format.html { redirect_to(@api_list, :notice => 'Api list was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @api_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /api_lists/1
  # DELETE /api_lists/1.xml
  def destroy
    @api_list = ApiList.find_by_id(params[:id])
    @api_list.destroy

    respond_to do |format|
      format.html { redirect_to(api_lists_url) }
      format.xml  { head :ok }
    end
  end

  def api_destroy
    @api_list = ApiList.find_by_id(params[:id])
    @api_list.destroy
    respond_to do |format|
      format.html { redirect_to(api_lists_url) }
      format.xml  { head :ok }
    end
  end
end
