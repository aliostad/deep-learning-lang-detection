class Manage::UsersController < Manage::BaseController
  inherit_resources
  defaults :route_prefix => 'manage'
  
  before_filter :make_filter, :only=>[:index]
  before_filter :check_params, :only => [:create, :update]
  before_filter :find_user, :only=>[:update, :activate]

  load_and_authorize_resource  
  
  cache_sweeper :user_sweeper, :only=>[:update, :destroy]
  
  def create
    @user = User.new(params[:user])
    @user.roles_attributes = @roles
    create! { manage_users_path } 
  end
  
  def update
    @user.roles_attributes = @roles
    update!{ manage_users_path }
  end
  
  def destroy
    destroy!{ manage_users_path }
  end
  
  # POST /manage/users/1/activate
  def activate
    @user.confirm!    
    respond_with(@user, :location => manage_users_path)
  end
  
  # POST /manage/users/1/suspend
  def suspend
    @user.suspend! 
    respond_with(@user, :location => manage_users_path)
  end

  # POST /manage/users/1/unsuspend
  def unsuspend
    @user.unsuspend!
    respond_with(@user, :location => manage_users_path)
  end

  # POST /manage/users/1/delete
  def delete
    @user.delete!
    respond_with(@user, :location => manage_users_path)
  end
  
  protected
    
    def collection
      options = { :page => params[:page], :per_page => 20 }
      options.update @search.filter
      
      @users = (@users || end_of_association_chain).includes(:avatar).paginate(options)
    end
    
    def make_filter
      @search = Freeberry::ModelFilter.new(User, :attributes=>[:name, :email])
      @search.update_attributes(params[:search])
    end
    
    def check_params
      unless params[:user].blank?
        @roles = params[:user].delete(:roles_attributes)
        
        if params[:user][:password].blank?
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
        end
      end
    end
    
    def find_user
      @user = User.find(params[:id])
    end
end
