class Api::ClientsController < ApiController
  # GET /api/clients
  # GET /api/clients.json
  skip_before_filter :api_session_token_authenticate!, only: [:create, :new]
  def index
    @api_clients = Client.all

    render json: @api_clients
  end

  # GET /api/clients/1
  # GET /api/clients/1.json
  def show
    @api_client = Client.find(params[:id])

    render json: @api_client
  end

  # POST /api/clients
  # POST /api/clients.json
  def create
    puts params
    @api_client = Client.new(params["client"])

    if @api_client.save
      render json: @api_client, status: :created, location: @api_client
    else
      render json: @api_client.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/clients/1
  # PATCH/PUT /api/clients/1.json
  def update
    @api_client = Client.find(params[:id])

    if @api_client.update(params[:api_client])
      head :no_content
    else
      render json: @api_client.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/clients/1
  # DELETE /api/clients/1.json
  def destroy
    @api_client = Client.find(params[:id])
    @api_client.destroy

    head :no_content
  end
end
