
module Gitci
  class App < Sinatra::Base
    include Gitci::Helpers::Global
    helpers Sinatra::ContentFor

    if Gitci.config.enable_auth
      use Rack::Auth::Basic, "Restricted Area" do |username, password|
        [username, password] == [Gitci.config.username, Gitci.config.password]
      end
    end

    set :logging, true
    set :public_folder, File.expand_path("../../../public", __FILE__)
    set :views, File.expand_path("../../../lib/gitci/views", __FILE__)
    set :haml, :layout => :'layouts/application.html'

    configure :production do
    end

    configure :development do
      set :show_exceptions, true
    end

    helpers do
      include Rack::Utils
      alias_method :h, :escape_html
    end

    before do
    end

    get '/' do
      @repositories = Repository.all.order(:created_at.desc)

      haml :'welcome/index.html'
    end

    get '/repositories/new' do
      haml :'repositories/new.html'
    end

    get '/repositories' do
      @repositories = Repository.all.order(:created_at.desc)
      haml :'repositories/index.html'
    end

    get '/repositories/:id' do
      @repository = Repository.find(params[:id])

      haml :'repositories/show.html'
    end

    post '/repositories' do
      @repository = Repository.new(params[:repository])

      @repository.save!
      @repository.fetch!

      if params[:script]
        @repository.scripts.create(:command => params[:script])
      end

      redirect "/repositories/#{@repository.id}"
    end

    post '/repositories/:repository_id/scripts' do
      @repository = Repository.find(params[:repository_id])

      script = @repository.scripts.create(params[:script])

      BuildTask.create(:repository => @repository, :script => script, :git_ref => "origin/master")

      redirect "/repositories/#{@repository.id}"
    end

    get "/repositories/:repository_id/scripts/:id/delete" do
      @repository = Repository.find(params[:repository_id])

      @repository.scripts.find(params[:id]).destroy

      redirect "/repositories/#{@repository.id}"
    end

    get "/repositories/:repository_id/scripts/:id/edit" do
      @repository = Repository.find(params[:repository_id])
      @script = @repository.scripts.find(params[:id])
      haml :'scripts/edit.html'
    end

    post "/repositories/:repository_id/scripts/:id" do
      @repository = Repository.find(params[:repository_id])
      @script = @repository.scripts.find(params[:id])
      @script.update_attributes(params[:script])
      redirect "/repositories/#{@repository.id}"
    end

    get "/repositories/:repository_id/scripts/:id/run" do
      @repository = Repository.find(params[:repository_id])
      script = @repository.scripts.find(params[:id])

      BuildTask.create!(:repository => @repository, :script => script)

      redirect "/repositories/#{@repository.id}"
    end
  end
end

