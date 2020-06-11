class TimeChunksController < ApplicationController

  $data_table = "hive_data_store"

  # GET /time_chunks
  # GET /time_chunks.json
  def index
    redirect_to "http://ww.google.com"
    #@time_chunks =  $data_table #TimeChunk.all

    ##respond_to do |format|
      #format.html # index.html.erb
      #format.json { render json: @time_chunks }
    #end
  end

  # GET /time_chunks/1
  # GET /time_chunks/1.json
  def show
    @time_chunk = #TimeChunk.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @time_chunk }
    end
  end

  # GET /time_chunks/new
  # GET /time_chunks/new.json
  def new
    #@time_chunk = TimeChunk.new

    data_set = []
    date_time = Time.now
    
    params[:datapoints].each do |point|
      h = {:hive_id => 'my_id', :date_time => 123}
      point[:params].each {|key, value| h[key] = value}
      data_set.push(h)
    end

    @Batch_Hash = data_set

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @time_chunk }
    end
  end

  # GET /time_chunks/1/edit
  def edit
    #@time_chunk = #TimeChunk.find(params[:id])
  end

  # POST /time_chunks
  # POST /time_chunks.json
  def create
    data_set = []
    date_time = Time.now
    
    params[:datapoints].each do |point|
      h = {:hive_id => 'my_id', :date_time => 123}
      point[:params].each {|key, value| h[key] = value}
      data_set.push(h)
    end

    @Batch_Hash = data_set

  end

  # PUT /time_chunks/1
  # PUT /time_chunks/1.json
  def update
    @time_chunk = #TimeChunk.find(params[:id])

    respond_to do |format|
      if @time_chunk.update_attributes(params[:time_chunk])
        format.html { redirect_to @time_chunk, notice: 'Time chunk was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @time_chunk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_chunks/1
  # DELETE /time_chunks/1.json
  def destroy
    @time_chunk = #TimeChunk.find(params[:id])
    @time_chunk.destroy

    respond_to do |format|
      format.html { redirect_to time_chunks_url }
      format.json { head :no_content }
    end
  end
end
