class Manage::TokensController < ApplicationController
  before_action :set_manage_token, only: [:show, :edit, :update, :destroy]

  # GET /manage/tokens
  # GET /manage/tokens.json
  def index
    @tokens = current_user.tokens.all
  end

  # GET /manage/tokens/1
  # GET /manage/tokens/1.json
  def show
  end

  # GET /manage/tokens/new
  def new
    @token = Token.new
  end

  # GET /manage/tokens/1/edit
  def edit
  end

  # POST /manage/tokens
  # POST /manage/tokens.json
  def create
    @token = current_user.tokens.new(manage_token_params)

    respond_to do |format|
      if @token.save
        format.html { redirect_to manage_tokens_url, notice: 'Token was successfully created.' }
        format.json { render action: 'show', status: :created, location: @token }
      else
        format.html { render action: 'new' }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/tokens/1
  # PATCH/PUT /manage/tokens/1.json
  def update
    respond_to do |format|
      if @token.update(manage_token_params)
        format.html { redirect_to manage_tokens_url, notice: 'Token was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/tokens/1
  # DELETE /manage/tokens/1.json
  def destroy
    @token.destroy
    respond_to do |format|
      format.html { redirect_to manage_tokens_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_token
      @token = Token.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_token_params
      params.require(:token).permit(:is_active, :description, :username)
    end
end
