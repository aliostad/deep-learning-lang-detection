class Manage::EventsController < Manage::RootController
  
  # GET /manage/events
  # GET /manage/events.json
  def index
    @manage_events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @manage_events }
    end
  end

  # GET /manage/events/1
  # GET /manage/events/1.json
  def show
    @manage_event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manage_event }
    end
  end

  # GET /manage/events/new
  # GET /manage/events/new.json
  def new
    @manage_event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manage_event }
    end
  end

  # GET /manage/events/1/edit
  def edit
    @manage_event = Event.find(params[:id])
  end

  # POST /manage/events
  # POST /manage/events.json
  def create
    @manage_event = Event.new(params[:event])

    respond_to do |format|
      if @manage_event.save
        format.html { redirect_to [:manage, @manage_event], notice: 'Event was successfully created.' }
        format.json { render json: @manage_event, status: :created, location: @manage_event }
      else
        format.html { render action: "new" }
        format.json { render json: @manage_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manage/events/1
  # PUT /manage/events/1.json
  def update
    @manage_event = Event.find(params[:id])

    respond_to do |format|
      if @manage_event.update_attributes(params[:manage_event])
        format.html { redirect_to [:manage, @manage_event], notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @manage_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/events/1
  # DELETE /manage/events/1.json
  def destroy
    @manage_event = Event.find(params[:id])
    @manage_event.destroy

    respond_to do |format|
      format.html { redirect_to manage_events_url }
      format.json { head :ok }
    end
  end
end
