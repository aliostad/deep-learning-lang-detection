class ManagePosesController < ApplicationController
  before_action :set_manage_pose, only: [:show, :edit, :update, :destroy]

  # GET /manage_poses
  # GET /manage_poses.json
  def index
    @manage_poses = ManagePose.all
  end

  # GET /manage_poses/1
  # GET /manage_poses/1.json
  def show
  end

  # GET /manage_poses/new
  def new
    @manage_pose = ManagePose.new
  end

  # GET /manage_poses/1/edit
  def edit
  end

  # POST /manage_poses
  # POST /manage_poses.json
  def create
    @manage_pose = ManagePose.new(manage_pose_params)

    respond_to do |format|
      if @manage_pose.save
        format.html { redirect_to @manage_pose, notice: 'Manage pose was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_pose }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_pose.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_poses/1
  # PATCH/PUT /manage_poses/1.json
  def update
    respond_to do |format|
      if @manage_pose.update(manage_pose_params)
        format.html { redirect_to @manage_pose, notice: 'Manage pose was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_pose.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_poses/1
  # DELETE /manage_poses/1.json
  def destroy
    @manage_pose.destroy
    respond_to do |format|
      format.html { redirect_to manage_poses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_pose
      @manage_pose = ManagePose.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_pose_params
      params.require(:manage_pose).permit(:title, :sub_category, :author, :pose_image, :desc)
    end
end
