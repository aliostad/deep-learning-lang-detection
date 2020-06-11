class CalculatesController < ApplicationController
  before_action :set_calculate, only: [:show, :edit, :update, :destroy]

  # GET /calculates
  # GET /calculates.json
  def index
    @calculates = Calculate.order('spent_on')
    @calculate_per_day = @calculates.group_by { |c| c.spent_on.beginning_of_day }

  end

  # GET /calculates/1
  # GET /calculates/1.json
  def show
  end

  # GET /calculates/new
  def new
    @calculate = Calculate.new
  end

  # GET /calculates/1/edit
  def edit
  end

  # POST /calculates
  # POST /calculates.json
  def create
    @calculate = Calculate.new(calculate_params)

    respond_to do |format|
      if @calculate.save
        format.html { redirect_to @calculate, notice: 'Calculate was successfully created.' }
        format.json { render :show, status: :created, location: @calculate }
      else
        format.html { render :new }
        format.json { render json: @calculate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calculates/1
  # PATCH/PUT /calculates/1.json
  def update
    respond_to do |format|
      if @calculate.update(calculate_params)
        format.html { redirect_to @calculate, notice: 'Calculate was successfully updated.' }
        format.json { render :show, status: :ok, location: @calculate }
      else
        format.html { render :edit }
        format.json { render json: @calculate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calculates/1
  # DELETE /calculates/1.json
  def destroy
    @calculate.destroy
    respond_to do |format|
      format.html { redirect_to calculates_url, notice: 'Calculate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calculate
      @calculate = Calculate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calculate_params
      params.require(:calculate).permit(:name, :money_spent, :spent_on, :daily_sum)
    end

end
