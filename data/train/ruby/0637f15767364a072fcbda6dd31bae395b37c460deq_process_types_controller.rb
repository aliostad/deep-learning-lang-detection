class DeqProcessTypesController < ApplicationController
  before_action :set_deq_process_type, only: [:show, :edit, :update, :destroy]
  before_filter :get_message_types

  # GET /deq_process_types
  def index
    @deq_process_types = DeqProcessType.all
  end

  # GET /deq_process_types/1
  def show
  end

  # GET /deq_process_types/new
  def new
    @deq_process_type = DeqProcessType.new
  end

  # GET /deq_process_types/1/edit
  def edit
  end

  # POST /deq_process_types
  def create
    @deq_process_type = DeqProcessType.new(deq_process_type_params)

    if @deq_process_type.save
      redirect_to @deq_process_type, notice: 'Deq process type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /deq_process_types/1
  def update
    if @deq_process_type.update(deq_process_type_params)
      redirect_to @deq_process_type, notice: 'Deq process type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /deq_process_types/1
  def destroy
    @deq_process_type.destroy
    redirect_to deq_process_types_url, notice: 'Deq process type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deq_process_type
      @deq_process_type = DeqProcessType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def deq_process_type_params
      params.require(:deq_process_type).permit(:processTypeId, :message_sub_type_id, :originating_transactionId, :deq_response_id)
    end


    def get_message_types
      @message_sub_types = MessageSubType.all
    end

end
