class RepositoriesController <  ApplicationController

  def index
    @rep = Repository.all
    
  end

	def new
			@rep = Repository.new
			@projects = Project.all
			if @projects.empty?
				@projects = nil
			end

	end

	def show
  		  @rep= Repository.find(params[:id])
 	 end

 	 def create
 	 	
 

		@rep = Repository.for(params[:repository][:name].delete(" ")


		if !params[:repository].empty?
					
					if !params[:repository][:name].empty?
						@rep.name = params[:repository][:name]
					end

					if !params[:repository][:location].empty?
						@rep.location  = params[:repository][:location]
						
					end

					if !params[:repository][:web_browse_interface].empty?
						@rep.web_browse_interface  = params[:repository][:web_browse_interface]
					end

					if !params[:repository][:anonymous_root].empty?
						@rep.anonymous_root = params[:repository][:anonymous_root]
					end

				

				

					# begin
					# 	projeto = Projeto.find(params[:version][:teste][:releases].delete(" "))
						
					# 	add = RDF::Statement.new(projeto.to_uri , DOAP.release , @version.to_uri)
						
					# 	REPO.insert  add
						
					# rescue Exception => e
						
					# end
			
				

									
			end

		if @rep.save 
			 redirect_to @rep, :notice => 'Cadastro de Repository criado com sucesso!'
	      else
	        render :new
	    end
	end

end