Octomaps::Admin.controllers :repositories do
  get :index do
    @title = "Repositories"
    @repositories = Repository.all
    render 'repositories/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'repository')
    @repository = Repository.new
    render 'repositories/new'
  end

  post :create do
    @repository = Repository.new(params[:repository])
    if @repository.save
      @title = pat(:create_title, :model => "repository #{@repository.id}")
      flash[:success] = pat(:create_success, :model => 'Repository')
      params[:save_and_continue] ? redirect(url(:repositories, :index)) : redirect(url(:repositories, :edit, :id => @repository.id))
    else
      @title = pat(:create_title, :model => 'repository')
      flash.now[:error] = pat(:create_error, :model => 'repository')
      render 'repositories/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "repository #{params[:id]}")
    @repository = Repository.find(params[:id])
    if @repository
      render 'repositories/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'repository', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "repository #{params[:id]}")
    @repository = Repository.find(params[:id])
    if @repository
      if @repository.update_attributes(params[:repository])
        flash[:success] = pat(:update_success, :model => 'Repository', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:repositories, :index)) :
          redirect(url(:repositories, :edit, :id => @repository.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'repository')
        render 'repositories/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'repository', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Repositories"
    repository = Repository.find(params[:id])
    if repository
      if repository.destroy
        flash[:success] = pat(:delete_success, :model => 'Repository', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'repository')
      end
      redirect url(:repositories, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'repository', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Repositories"
    unless params[:repository_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'repository')
      redirect(url(:repositories, :index))
    end
    ids = params[:repository_ids].split(',').map(&:strip)
    repositories = Repository.find(ids)
    
    if Repository.destroy repositories
    
      flash[:success] = pat(:destroy_many_success, :model => 'Repositories', :ids => "#{ids.to_sentence}")
    end
    redirect url(:repositories, :index)
  end
end
