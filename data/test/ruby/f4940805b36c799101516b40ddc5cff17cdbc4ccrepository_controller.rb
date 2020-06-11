class RepositoryController < ApplicationController
  def index
   @repositorys = Repository.paginate( :page=>params[:page], :per_page=>10).order("itemNo").all
  
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @Repositorys }
      format.csv { render text: @Repositorys.to_csv }
#      format.xls { send_data @Repositorys.to_csv(col_sep: "\t") }
      format.xls
    end
  end

  def import

#   input material
#   Repository.import(params[:file])
#	  redirect_to repository_index_path, notice: "Products imported."

    @a=[]
	  Repository.import(params[:file], params[:search])
	  @a=Repository.cal
	  @b=Repository.calu
	redirect_to repository_index_path, notice: params[:search].empty? ?  "repository can make up #{@a.min}" : params[:search].to_i<=0 ? "enter wrong number, number must greater than 0" : "#{@b}" 
  end
  
   def show
    @repository = Repository.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /Repositorys/new
  # GET /Repositorys/new.json
  def new
    @repository = Repository.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /Repositorys/1/edit
  def edit
    @repository = Repository.find(params[:id])
  end

  # POST /Repositorys
  # POST /Repositorys.json
  def create
    @repository = Repository.new(params[:repository])

    respond_to do |format|
      if @repository.save
        format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
        format.json { render json: @repository, status: :created, location: @Repository }
      else
        format.html { render action: "new" }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /Repositorys/1
  # PUT /Repositorys/1.json
  def update
    @repository = Repository.find(params[:id])

    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        format.html { redirect_to @repository, notice: 'Repository was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Repositorys/1
  # DELETE /Repositorys/1.json
  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to repository_index_path }
      format.json { head :no_content }
    end
  end
end
