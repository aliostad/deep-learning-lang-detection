class RepositoriesController < PrivateController
  def index
    @repository = current_user.repositories.first

    if @repository
      redirect_to repository_path(@repository)
    else
      redirect_to user_path
    end
  end

  def create
    @repository = current_user.link_repository("#{params[:owner_name]}/#{params[:name]}")

    redirect_to repository_path(@repository)
  end

  def show
    @repository = repository_from_path
  end

  def status
    headers['Expires'] = CGI.rfc1123_date(Time.now.utc)

    @repository = repository_from_path

    result = case Build::RESULT[@repository.builds.last.try(:result)]
    when :ok
      'green'
    when :fail
      'red'
    else
      'grey'
    end

    path = Rails.root.join('public','result',"#{result}.gif")
    send_file(path, :type => 'image/gif', :disposition => 'inline')
  end
end
