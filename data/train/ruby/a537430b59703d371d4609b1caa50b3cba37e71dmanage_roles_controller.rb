class Admin::ManageRolesController < ApplicationController
  include ApplicationHelper
  
  layout "admin"
  before_filter :authorize, :except => 'login',
  :role => 'administrator', 
  :msg => 'Access to this page is restricted.'
  
  def initialize
    super
    seek = SearchController.new();
    @filter_tab = SearchTabFilter.load_filter;
    @linkMenu = seek.load_menu;
    @groups_tab = SearchTab.load_groups;
    @primaryDocumentTypes = PrimaryDocumentType.find(:all)
  end
  
  # GET /admin_manage_roles
  # GET /admin_manage_roles.xml
  def index
    @manage_roles = ManageRole.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @manage_roles }
    end
  end
  
  # GET /admin_manage_roles/1
  # GET /admin_manage_roles/1.xml
  def show
    @manage_roles = ManageRole.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @manage_roles }
    end
  end
  
  # GET /admin_manage_roles/new
  # GET /admin_manage_roles/new.xml
  def new
    @manage_roles = ManageRole.new();
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @manage_roles }
    end
  end
  
  # POST /admin_manage_roles
  # POST /admin_manage_roles.xml
  def create
    if ((params[:manage_role].blank?) || (params[:manage_role][:id_role].blank?))
      redirect_to :action => 'new'     
      return ;
    end
    @manage_roles = ManageRole.new()
    @manage_roles.id_role = params[:manage_role][:id_role];
    
    respond_to do |format|
      if (@manage_roles.save)
        flash[:notice] = 'Admin::ManageRoles was successfully created.'
        format.html { redirect_to(:action => "index") }
        format.xml  { render :xml => @manage_roles, :status => :created, :location => @manage_roles }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @manage_roles.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  # DELETE /admin_manage_roles/1
  # DELETE /admin_manage_roles/1.xml
  def destroy
    @manage_roles = ManageRole.find(params[:id])
    @manage_roles.destroy
    
    respond_to do |format|
      format.html { redirect_to(admin_manage_roles_url) }
      format.xml  { head :ok }
    end
  end
end
