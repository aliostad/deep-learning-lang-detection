module Kernel
  def set_repository_root(repository_root)
    Thread.current['repository'] = Git.open(repository_root) if repository_root.to_s.length > 5
  end
  def mygit_path
    Thread.current['repository'] ? mygit.dir.path : nil
  end
  def mygit
    set_repository_root('./././.') unless Thread.current['repository']
    Thread.current['repository']
  end
end

class Repositories < Application
  skip_before :get_repository_root

  def index
    render
  end

  def choose(repository_root=nil)
    session[:repository_root] = repository_root
    if session[:repository_root]
      redirect '/'
    else
      render :choose
    end
  end
end
