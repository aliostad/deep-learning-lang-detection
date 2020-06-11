class Manage::ContestsController < ManageController
  before_action :set_manage_contest, only: [:show, :edit, :update, :destroy]

  # GET /manage/contests
  # GET /manage/contests.json
  def index
    @manage_contests = Manage::Contest.order(is_deleted: :desc,id: :desc)
  end

  # GET /manage/contests/1
  # GET /manage/contests/1.json
  def show
  end

  # GET /manage/contests/new
  def new
    @manage_contest = Manage::Contest.new
  end

  # GET /manage/contests/1/edit
  def edit
  end

  # POST /manage/contests
  # POST /manage/contests.json
  def create
    @manage_contest = Manage::Contest.new(manage_contest_params)

    respond_to do |format|
      if @manage_contest.save
        format.html { redirect_to @manage_contest, notice: 'Contest was successfully created.' }
        format.json { render :show, status: :created, location: @manage_contest }
      else
        format.html { render :new }
        format.json { render json: @manage_contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/contests/1
  # PATCH/PUT /manage/contests/1.json
  def update
    respond_to do |format|
      if @manage_contest.update(manage_contest_params)
        format.html { redirect_to @manage_contest, notice: 'Contest was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_contest }
      else
        format.html { render :edit }
        format.json { render json: @manage_contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/contests/1
  # DELETE /manage/contests/1.json
  def destroy
    @manage_contest.is_deleted = true
    @manage_contest.save
    respond_to do |format|
      format.html { redirect_to manage_contests_url, notice: '比赛类别已被放入回收箱.' }
      format.json { head :no_content }
    end
  end

  # DELETE /manage/contests/1/recover
  # DELETE /manage/contests/1/recover.json
  def recover
    @manage_contest = Manage::Contest.find(params[:contest_id])
    @manage_contest.is_deleted = false
    @manage_contest.save
    respond_to do |format|
      format.html { redirect_to manage_contests_url, notice: "#{@manage_contest.name}已恢复." }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_contest
      @manage_contest = Manage::Contest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_contest_params
      param = params.require(:manage_contest).permit(:name, :fullname, :description, :summary, :level, :organizer, :website_url,:cover)
      param[:admin_id] = @admin.id
      param
    end
end
