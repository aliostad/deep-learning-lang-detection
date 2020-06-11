class ManageFollowUsController < ApplicationController
  before_action :set_manage_follow_u, only: [:show, :edit, :update, :destroy]

  # GET /manage_follow_us
  # GET /manage_follow_us.json
  def index
    @manage_follow_us = ManageFollowU.all
  end

  # GET /manage_follow_us/1
  # GET /manage_follow_us/1.json
  def show
  end

  # GET /manage_follow_us/new
  def new
    @manage_follow_u = ManageFollowU.new
  end

  # GET /manage_follow_us/1/edit
  def edit
  end

  # POST /manage_follow_us
  # POST /manage_follow_us.json
  def create
    @manage_follow_u = ManageFollowU.new(manage_follow_u_params)

    respond_to do |format|
      if @manage_follow_u.save
        format.html { redirect_to @manage_follow_u, notice: 'Manage follow u was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_follow_u }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_follow_u.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_follow_us/1
  # PATCH/PUT /manage_follow_us/1.json
  def update
    respond_to do |format|
      if @manage_follow_u.update(manage_follow_u_params)
        format.html { redirect_to @manage_follow_u, notice: 'Manage follow u was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_follow_u.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_follow_us/1
  # DELETE /manage_follow_us/1.json
  def destroy
    @manage_follow_u.destroy
    respond_to do |format|
      format.html { redirect_to manage_follow_us_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_follow_u
      @manage_follow_u = ManageFollowU.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_follow_u_params
      params.require(:manage_follow_u).permit(:facebook_url, :twitter_url, :google_url, :youtube_url, :ping_url, :vimeo_url, :tumbir_url, :rss_url, :flickr_url)
    end
end
