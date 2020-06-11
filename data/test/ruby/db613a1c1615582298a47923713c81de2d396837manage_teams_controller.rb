class ManageTeamsController < ApplicationController
  before_action :set_manage_team, only: [:show, :edit, :update, :destroy]

  # GET /manage_teams
  # GET /manage_teams.json
  def index
    @manage_teams = ManageTeam.all
  end

  # GET /manage_teams/1
  # GET /manage_teams/1.json
  def show
  end

  # GET /manage_teams/new
  def new
    @manage_team = ManageTeam.new
  end

  # GET /manage_teams/1/edit
  def edit
  end

  # POST /manage_teams
  # POST /manage_teams.json
  def create
    @manage_team = ManageTeam.new(manage_team_params)

    respond_to do |format|
      if @manage_team.save
        format.html { redirect_to @manage_team, notice: 'Manage team was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_team }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_teams/1
  # PATCH/PUT /manage_teams/1.json
  def update
    respond_to do |format|
      if @manage_team.update(manage_team_params)
        format.html { redirect_to @manage_team, notice: 'Manage team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_teams/1
  # DELETE /manage_teams/1.json
  def destroy
    @manage_team.destroy
    respond_to do |format|
      format.html { redirect_to manage_teams_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_team
      @manage_team = ManageTeam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_team_params
      params.require(:manage_team).permit(:name, :image, :position, :desc)
    end
end
