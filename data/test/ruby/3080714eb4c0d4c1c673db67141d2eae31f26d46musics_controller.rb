class Manage::MusicsController < Manage::RootController
  layout "manage_facebox"
  
  # GET /manage/musics
  # GET /manage/musics.json
  def index
    @manage_musics = Music.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @manage_musics }
    end
  end

  # GET /manage/musics/1
  # GET /manage/musics/1.json
  def show
    @manage_music = Music.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manage_music }
    end
  end

  # GET /manage/musics/new
  # GET /manage/musics/new.json
  def new
    @manage_music = Music.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manage_music }
    end
  end

  # GET /manage/musics/1/edit
  def edit
    @manage_music = Music.find(params[:id])
  end

  # POST /manage/musics
  # POST /manage/musics.json
  def create
    @manage_music = Music.new(params[:manage_music])

    respond_to do |format|
      if @manage_music.save
        format.html { redirect_to @manage_music, notice: 'Music was successfully created.' }
        format.json { render json: @manage_music, status: :created, location: @manage_music }
      else
        format.html { render action: "new" }
        format.json { render json: @manage_music.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manage/musics/1
  # PUT /manage/musics/1.json
  def update
    @manage_music = Music.find(params[:id])

    respond_to do |format|
      if @manage_music.update_attributes(params[:manage_music])
        format.html { redirect_to @manage_music, notice: 'Music was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @manage_music.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/musics/1
  # DELETE /manage/musics/1.json
  def destroy
    @manage_music = Music.find(params[:id])
    @manage_music.destroy

    respond_to do |format|
      format.html { redirect_to manage_musics_url }
      format.json { head :ok }
    end
  end
end
