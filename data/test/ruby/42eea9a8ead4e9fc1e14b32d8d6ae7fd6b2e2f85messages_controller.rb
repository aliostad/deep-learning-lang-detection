class Api::MessagesController < ApiController
  # GET /api/messages
  # GET /api/messages.json
  def index
    @api_messages = Message.all

    render json: @api_messages
  end

  # GET /api/messages/1
  # GET /api/messages/1.json
  def show
    @api_message = Message.find(params[:id])

    render json: @api_message
  end

  # POST /api/messages
  # POST /api/messages.json
  def create
    @api_message = Message.new(params[:api_message])

    if @api_message.save
      render json: @api_message, status: :created, location: @api_message
    else
      render json: @api_message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/messages/1
  # PATCH/PUT /api/messages/1.json
  def update
    @api_message = Message.find(params[:id])

    if @api_message.update(params[:api_message])
      head :no_content
    else
      render json: @api_message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/messages/1
  # DELETE /api/messages/1.json
  def destroy
    @api_message = Message.find(params[:id])
    @api_message.destroy

    head :no_content
  end
end
