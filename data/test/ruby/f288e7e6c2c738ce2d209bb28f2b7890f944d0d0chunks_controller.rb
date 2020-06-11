class ChunksController < ApplicationController
  before_filter :require_user
  
  # GET /chunks
  # GET /chunks.xml
  def index
    @chunks = Chunk.all.sort_by { |c| c.display_title }.
      paginate(params)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @chunks }
    end
  end

  # GET /chunks/1
  # GET /chunks/1.xml
  def show
    @chunk = Chunk.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @chunk }
    end
  end

  # GET /chunks/new
  # GET /chunks/new.xml
  def new
    @works = Work.all.sort_by { |w| w.select_name }
    @chunk = Chunk.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chunk }
    end
  end

  # GET /chunks/1/edit
  def edit
    @works = Work.all.sort_by { |w| w.select_name }
    @chunk = Chunk.find(params[:id])
  end

  # POST /chunks
  # POST /chunks.xml
  def create
    @chunk = Chunk.new(params[:chunk])

    respond_to do |format|
      if @chunk.save
        format.html { redirect_to(@chunk, :notice => 'Chunk was successfully created.') }
        format.xml  { render :xml => @chunk, :status => :created, :location => @chunk }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chunk.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /chunks/1
  # PUT /chunks/1.xml
  def update
    @chunk = Chunk.find(params[:id])

    respond_to do |format|
      if @chunk.update_attributes(params[:chunk])
        format.html { redirect_to(@chunk, :notice => 'Chunk was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chunk.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /chunks/1
  # DELETE /chunks/1.xml
  def destroy
    @chunk = Chunk.find(params[:id])
    @chunk.destroy

    respond_to do |format|
      format.html { redirect_to(chunks_url) }
      format.xml  { head :ok }
    end
  end
end
