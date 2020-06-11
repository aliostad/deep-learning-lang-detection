class Admin::ManageDroitsController < ApplicationController
  include ApplicationHelper
  layout 'admin'
  
  before_filter :authorize, :except => 'login',
  :role => 'administrator', 
  :msg => 'Access to this page is restricted.'
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    cleanFlash();
    @manageDroit  = ManageDroit.find(:all, :select => "*", :order => "id_role ASC, id_lieu ASC, id_perm ASC", 
                :joins => "LEFT JOIN collections ON collections.id = manage_droits.id_collection NATURAL LEFT JOIN manage_roles NATURAL LEFT JOIN manage_permissions");
    @profilePost  = ProfilPostes.findAll(); 
    @manageRole   = ManageRole.find(:all);
    @managePerm   = ManagePermission.find(:all);
    @collection   = Collection.find(:all);
    return ;
  end
  
  def cleanFlash
    flash[:notice] = "";
    flash[:error] = "";
  end
  
  def new
    cleanFlash();
    status = 0;
    if ((!params['manage_droit'].blank?) &&
     (!params['manage_droit']['id_collection'].blank?) &&
     (!params['manage_droit']['id_perm'].blank?) &&
     (params['manage_droit']['id_perm'] != 'None'))
      
      @managePerm                 = ManagePermission.find(:all);
      @manage_droit               = ManageDroit.new();
      @manage_droit.id_collection = params[:manage_droit][:id_collection];
      @manage_droit.id_lieu       = params[:manage_droit][:id_lieu];
      @manage_droit.id_perm       = params[:manage_droit][:id_perm];
      @manage_droit.id_role       = params[:manage_droit][:id_role];
      @collection                 = Collection.find(@manage_droit.id_collection);
      @update                     = ManageDroit.find(:all, :conditions => 
                                        "id_role = '#{@manage_droit.id_role}' and id_collection = #{@manage_droit.id_collection} and id_lieu = '#{@manage_droit.id_lieu}'")
      
      begin
        @update.each do |del|
          puts del.id_perm
          puts @manage_droit.id_perm
          if (del.id_perm == @manage_droit.id_perm)
            raise "exist";
          end
          status = 2;
          del.delete();
        end
      rescue => e
        status = 1;
        if (e.message == "exist")
          flash[:error] = 'Error object existing'
        else
          flash[:error] = 'Error while create object'
        end
      end
      if (status != 1)
        begin
          @manage_droit.save!()
          flash[:notice] = 'Object Saved'
        rescue => e
          flash[:error] = 'Error while save object :-('
          status = 1;
        end
      end
    else
      flash[:error] = 'Error : please choose a valid permission';
      status = 1;
    end
    render :update do |page|
      page.replace_html('status', :partial => 'message')
      if (status == 0)
        page.insert_html(:before, params['id'], :partial => 'news')
        @collection = Collection.find(:all);
        page.replace("selectCollection_#{params[:manage_droit][:id_role]}_#{params[:manage_droit][:id_lieu]}", 
                            :partial  => 'selectCollection', 
                            :locals   => {
                                :id_role => params[:manage_droit][:id_role],
                                :id_lieu => params[:manage_droit][:id_lieu],
        }
        )
      end
      if (status == 2)
        page.call(:changeSelectedElementById, "update_#{@manage_droit.id_lieu}_#{@manage_droit.id_role}_#{@manage_droit.id_collection}")
      end
    end
    return ;
  end
  
  def update
    cleanFlash();
    if ((!params.blank?) &&
     (!params['id_collection'].blank?) &&
     (!params['id_perm'].blank?) &&
     (!params['id_role'].blank?) &&
     (!params['id_lieu'].blank?))
      #@manage_droit = ManageDroit.find("'" + params[:id_perm] + ',' + params[:id_role] + ',' + params[:id_collection] + ',' + params[:id_lieu] + "'")
      @manage_droit  = ManageDroit.find(:all, :conditions => 
                             "id_role = '#{params[:id_role]}' and id_collection = #{params[:id_collection]} and id_lieu = '#{params[:id_lieu]}'")
      begin
        @manage_droit.each do |del|
          del.delete();
        end
      rescue => e
        flash[:error] = 'Error while destroy object :-('
      end
      
      manage_droit = ManageDroit.new();
      manage_droit.id_lieu = params[:id_lieu];
      manage_droit.id_role = params[:id_role];
      manage_droit.id_collection = params[:id_collection];
      manage_droit.id_perm = params[:id_perm];
      
      begin
        manage_droit.save!()
        flash[:notice] = 'Update successful !'
      rescue
        flash[:error] = 'Error while save object :-('
      end
    end
    render :update do |page|
      page.replace_html('status', :partial => 'message', :locals => {:flash => flash})
    end
    return ;
  end
  
  def delete
    cleanFlash();
    status = 0;
    if ((!params.blank?) &&
     (!params['id_collection'].blank?) &&
     (!params['id_perm'].blank?) &&
     (!params['id_role'].blank?) &&
     (!params['id_lieu'].blank?))
      #@manage_droit = ManageDroit.find("'" + params[:id_perm] + ',' + params[:id_role] + ',' + params[:id_collection] + ',' + params[:id_lieu] + "'")
      @manage_droit  = ManageDroit.find(:all, :conditions => 
                             "id_role = '#{params[:id_role]}' and id_collection = #{params[:id_collection]} and id_lieu = '#{params[:id_lieu]}'")
      @collection   = Collection.find(:all);
      begin
        @manage_droit.each do |del|
          del.delete();
        end
        flash[:notice] = "Object destroy successfully !"
      rescue => e
        flash[:error] = 'Error while destroy object :-('
        status = 1;
      end
    end
    render :update do |page|
      page.replace_html('status', :partial => 'message', :locals => {:flash => flash});
      if (status == 0)
        page.remove("line_#{params['id_lieu']}_#{params['id_role']}_#{params['id_collection']}")
        page.replace("selectCollection_#{params[:id_role]}_#{params[:id_lieu]}", 
                            :partial  => 'selectCollection', 
                            :locals   => {
                                :id_role => params[:id_role],
                                :id_lieu => params[:id_lieu],
        }
        )
      end
    end
    return ;
  end
end
