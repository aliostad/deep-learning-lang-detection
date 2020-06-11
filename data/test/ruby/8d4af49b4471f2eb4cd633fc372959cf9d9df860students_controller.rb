class Manage::StudentsController < ManageController
  before_action :set_manage_student, only: [:show, :edit, :update, :destroy]

  # GET /manage/students
  # GET /manage/students.json
  def index
    @total_count = Manage::Student.count()
    puts @total_count
    offset = params[:start]
    limit = params[:limit]
    query = '%' + params[:query].to_s + '%'
    @manage_students = Manage::Student.where("stuid like ? or name like ?",query,query).limit(limit).offset(offset)
  end

  # GET /manage/students/1
  # GET /manage/students/1.json
  def show
  end

  # GET /manage/students/new
  def new
    @manage_student = Manage::Student.new
  end

  # GET /manage/students/1/edit
  def edit
  end

  # POST /manage/students
  # POST /manage/students.json
  def create
    @manage_student = Manage::Student.new(manage_student_params)

    respond_to do |format|
      if @manage_student.save
        format.html { redirect_to @manage_student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @manage_student }
      else
        format.html { render :new }
        format.json { render json: @manage_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/students/1
  # PATCH/PUT /manage/students/1.json
  def update
    respond_to do |format|
      if @manage_student.update(manage_student_params)
        format.html { redirect_to @manage_student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_student }
      else
        format.html { render :edit }
        format.json { render json: @manage_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/students/1
  # DELETE /manage/students/1.json
  def destroy
    @manage_student.destroy
    respond_to do |format|
      format.html { redirect_to manage_students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_student
      @manage_student = Manage::Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_student_params
      params.require(:manage_student).permit(:stuid, :name, :pwd, :email, :phone, :grade, :avatar)
    end
end
