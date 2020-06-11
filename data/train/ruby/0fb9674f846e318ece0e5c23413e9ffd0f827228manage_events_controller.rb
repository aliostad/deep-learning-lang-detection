class ManageEventsController < ApplicationController
  before_action :set_manage_event, only: [:show, :edit, :update, :destroy]

  # GET /manage_events
  # GET /manage_events.json
  def index
    @manage_events = ManageEvent.all
  end

  # GET /manage_events/1
  # GET /manage_events/1.json
  def show
  end

  # GET /manage_events/new
  def new
    @manage_event = ManageEvent.new
  end

  # GET /manage_events/1/edit
  def edit
  end

  # POST /manage_events
  # POST /manage_events.json
  def create
    @manage_event = ManageEvent.new(manage_event_params)

    respond_to do |format|
      if @manage_event.save
        format.html { redirect_to @manage_event, notice: 'Manage event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_event }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_events/1
  # PATCH/PUT /manage_events/1.json
  def update
    respond_to do |format|
      if @manage_event.update(manage_event_params)
        format.html { redirect_to @manage_event, notice: 'Manage event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_events/1
  # DELETE /manage_events/1.json
  def destroy
    @manage_event.destroy
    respond_to do |format|
      format.html { redirect_to manage_events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_event
      @manage_event = ManageEvent.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_event_params
      params.require(:manage_event).permit(:title, :category, :author, :event_date, :event_image, :desc, :start_at, :end_at, :name, event_images_attributes: [:file])
    end
end
