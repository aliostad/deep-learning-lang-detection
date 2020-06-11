class ManagesController < ApplicationController
  before_action :set_manage, only: [:show, :edit, :update, :destroy]

  protect_from_forgery :except => :sign_in
  # GET /manages
  # GET /manages.json
  def index
    @manages = Manage.all
  end

  # GET /manages/1
  # GET /manages/1.json
  def show
  end

  # GET /manages/new
  def new
    @manage = Manage.new
  end

  # GET /manages/1/edit
  def edit
  end

  #Sign_in
  def sign_in
    manage = Manage.find_by(username: params[:manage][:username])
    if captcha_valid?params[:manage][:captcha]
      if manage && manage.authenticate(params[:manage][:password])
        date = Time.new
        date = date.strftime("%Y-%m-%d")
        manage.update_attribute(:logintime, date)

        redirect_to '/static_pages/main'
      else
        flash[:alert] = '用户名或密码错误' # Not quite right!
        redirect_to '/static_pages/login'
      end
    else
      flash[:alert] = "验证码错误"
      redirect_to '/static_pages/login'
    end
  end

  # POST /manages
  # POST /manages.json
  def create
    @manage = Manage.new(manage_params)
    @manage.mid=UUIDTools::UUID.timestamp_create().to_s
    respond_to do |format|
      if @manage.save
        format.html { redirect_to @manage, notice: 'Manage was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manages/1
  # PATCH/PUT /manages/1.json
  def update
    respond_to do |format|
      if @manage.update(manage_params)
        format.html { redirect_to @manage, notice: 'Manage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manages/1
  # DELETE /manages/1.json
  def destroy
    @manage.destroy
    respond_to do |format|
      format.html { redirect_to manages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage
      @manage = Manage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_params
      params.require(:manage).permit(:username, :password, :password_confirmation, :image, :logintime, :status)
    end
end
