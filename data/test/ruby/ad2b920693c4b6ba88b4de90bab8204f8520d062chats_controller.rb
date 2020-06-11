class Api::ChatsController < ApiController
  # GET /api/chats
  # GET /api/chats.json
  def index
    @api_chats = Chat.all

    render json: @api_chats
  end

  # GET /api/chats/1
  # GET /api/chats/1.json
  def show
    @api_chat = Chat.find(params[:id])

    render json: @api_chat
  end

  # POST /api/chats
  # POST /api/chats.json
  def create
    @api_chat = Chat.new(params[:api_chat])

    if @api_chat.save
      render json: @api_chat, status: :created, location: @api_chat
    else
      render json: @api_chat.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/chats/1
  # PATCH/PUT /api/chats/1.json
  def update
    @api_chat = Chat.find(params[:id])

    if @api_chat.update(params[:api_chat])
      head :no_content
    else
      render json: @api_chat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/chats/1
  # DELETE /api/chats/1.json
  def destroy
    @api_chat = Chat.find(params[:id])
    @api_chat.destroy

    head :no_content
  end
end
