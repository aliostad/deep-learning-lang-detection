module Admin
  class ApiUsersController < Admin::ApplicationController
    before_action :set_api_user, only: [:show, :edit, :update, :destroy]
    respond_to :html, :js

    # GET /api_users
    # GET /api_users.json
    def index
      @api_users = ApiUser.all
    end

    # GET /api_users/1
    # GET /api_users/1.json
    def show

    end

    # GET /api_users/new
    def new
      @api_user = ApiUser.new
      @api_user.appid = [*'a'..'z',*'0'..'9',*'A'..'Z'].sample(20).join
      @api_user.appkey = [*'a'..'z',*'0'..'9',*'A'..'Z'].sample(30).join
      respond_with @api_user
    end

    # GET /api_users/1/edit
    def edit
    end

    # POST /api_users
    # POST /api_users.json
    def create
      @api_user = ApiUser.new(api_user_params)

      if @api_user.save
        flash[:notice] = "创建成功"
        respond_with @api_user
      else
        flash[:error] = "创建失败"
        render :new
      end
    end

    # PATCH/PUT /api_users/1
    # PATCH/PUT /api_users/1.json
    def update
      respond_to do |format|
        if @api_user.update(api_user_params)
          format.html { redirect_to @api_user, notice: 'Api user was successfully updated.' }
          format.json { render :show, status: :ok, location: @api_user }
        else
          format.html { render :edit }
          format.json { render json: @api_user.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /api_users/1
    # DELETE /api_users/1.json
    def destroy
      @api_user.destroy
      redirect_to admin_api_users_path
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_api_user
        @api_user = ApiUser.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def api_user_params
        params.require(:api_user).permit(:appid, :appkey, :company, :name, :email, :tel)
      end
  end
end
