class RailsWorkingCopiesController < WorkingCopiesController

	def precompile_as
		@working_copy = WorkingCopy.find(params[:id])

		@output = @working_copy.precompile_as

		@repository = Repository.find_by_id(@working_copy.repository.id)
		@working_copies = WorkingCopy.find_all_by_repository_id(@repository.id)

		@notice = _('Assets precompiled successfull')

		respond_to do |format|
			format.html { render :action => :index, :repository_id => @working_copy.repository.id}
		end
	end

	def db_migrate
		@working_copy = WorkingCopy.find(params[:id])

		@output = @working_copy.db_migrate

		@repository = Repository.find_by_id(@working_copy.repository.id)
		@working_copies = WorkingCopy.find_all_by_repository_id(@repository.id)

		@notice = _('Database migrated successfull')

		respond_to do |format|
			format.html { render :action => :index, :repository_id => @working_copy.repository.id}
		end
	end

	def serv_restart
		@working_copy = WorkingCopy.find(params[:id])

		@output = @working_copy.serv_restart

		@repository = Repository.find_by_id(@working_copy.repository.id)
		@working_copies = WorkingCopy.find_all_by_repository_id(@repository.id)

		@notice = _('Server restarted successfull')

		respond_to do |format|
			format.html { render :action => :index, :repository_id => @working_copy.repository.id}
		end
	end
	
	def bundle_install
		@working_copy = WorkingCopy.find(params[:id])

		@output = @working_copy.bundle_install

		@repository = Repository.find_by_id(@working_copy.repository.id)
		@working_copies = WorkingCopy.find_all_by_repository_id(@repository.id)
		
		@notice = _('Gems installed successfully')

		respond_to do |format|
			format.html { render :action => :index, :repository_id => @working_copy.repository.id}
		end
	end

	def all_tasks
		@working_copy = WorkingCopy.find(params[:id])

		@output = _("Running bundle")+":\n"+@working_copy.bundle_install
		@output = _("Compiling assets")+":\n"+@output + "\n\n" + @working_copy.precompile_as
		@output = _("Migrating database")+":\n"+@output + "\n\n" + @working_copy.db_migrate
		@output = _("Restarting server")+":\n"+@output+@working_copy.serv_restart

		@repository = Repository.find_by_id(@working_copy.repository.id)
		@working_copies = WorkingCopy.find_all_by_repository_id(@repository.id)

		@notice = _('All tasks performed successfully')

		respond_to do |format|
			format.html { render :action => :index, :repository_id => @working_copy.repository.id}
		end
	end

end