class Api::ClientsController < ApplicationController
  # GET /api/clients
  # GET /api/clients.json
  def index
    @api_clients = Api::Client.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @api_clients }
    end
  end

  # GET /api/clients/1
  # GET /api/clients/1.json
  def show
    @api_client = Api::Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @api_client }
    end
  end

  # GET /api/clients/new
  # GET /api/clients/new.json
  def new
    @api_client = Api::Client.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @api_client }
    end
  end

  # GET /api/clients/1/edit
  def edit
    @api_client = Api::Client.find(params[:id])
  end

  # POST /api/clients
  # POST /api/clients.json
  def create
    @api_client = Api::Client.new(params[:api_client])

    respond_to do |format|
      if @api_client.save
        format.html { redirect_to @api_client, notice: 'Client was successfully created.' }
        format.json { render json: @api_client, status: :created, location: @api_client }
      else
        format.html { render action: "new" }
        format.json { render json: @api_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /api/clients/1
  # PUT /api/clients/1.json
  def update
    @api_client = Api::Client.find(params[:id])

    respond_to do |format|
      if @api_client.update_attributes(params[:api_client])
        format.html { redirect_to @api_client, notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @api_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/clients/1
  # DELETE /api/clients/1.json
  def destroy
    @api_client = Api::Client.find(params[:id])
    @api_client.destroy

    respond_to do |format|
      format.html { redirect_to api_clients_url }
      format.json { head :no_content }
    end
  end
end
