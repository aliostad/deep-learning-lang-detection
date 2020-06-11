class ApiCallsController < ApplicationController
  # GET /api_calls
  # GET /api_calls.json
  def index
    @api_calls = ApiCall.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @api_calls }
    end
  end

  # GET /api_calls/1
  # GET /api_calls/1.json
  def show
    @api_call = ApiCall.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @api_call }
    end
  end

  # GET /api_calls/new
  # GET /api_calls/new.json
  def new
    @api_call = ApiCall.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @api_call }
    end
  end

  # GET /api_calls/1/edit
  def edit
    @api_call = ApiCall.find(params[:id])
  end

  # POST /api_calls
  # POST /api_calls.json
  def create
    @api_call = ApiCall.new(params[:api_call])

    respond_to do |format|
      if @api_call.save
        format.html { redirect_to @api_call, notice: 'Api call was successfully created.' }
        format.json { render json: @api_call, status: :created, location: @api_call }
      else
        format.html { render action: "new" }
        format.json { render json: @api_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /api_calls/1
  # PUT /api_calls/1.json
  def update
    @api_call = ApiCall.find(params[:id])

    respond_to do |format|
      if @api_call.update_attributes(params[:api_call])
        format.html { redirect_to @api_call, notice: 'Api call was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @api_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_calls/1
  # DELETE /api_calls/1.json
  def destroy
    @api_call = ApiCall.find(params[:id])
    @api_call.destroy

    respond_to do |format|
      format.html { redirect_to api_calls_url }
      format.json { head :no_content }
    end
  end
end
