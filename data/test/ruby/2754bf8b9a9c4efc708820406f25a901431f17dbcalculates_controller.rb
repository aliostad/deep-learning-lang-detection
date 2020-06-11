class CalculatesController < ApplicationController
  before_action :set_calculate, only: [:show, :edit, :update, :destroy]

  # GET /calculates
  # GET /calculates.json
  def index
    @calculates = Calculate.all
  end

  # GET /calculates/1
  # GET /calculates/1.json
  def show

    @components = Component.where(:product_id => @calculate.product.id)


    @components_materia_prima = @components.joins(:ingredient).where(ingredients: {material_type:'Materia Prima'})

    @components_material_empaque_primario = @components.joins(:ingredient).where(ingredients: {material_type:'Material Empaque 1o'})

    @components_material_empaque_secundario = @components.joins(:ingredient).where(ingredients: {material_type:'Material Empaque 2o'})
  end

  # GET /calculates/new
  def new
    @calculate                = Calculate.new
    @calculate.product_id     = params[:id]
    
    
  end

  # GET /calculates/1/edit
  def edit

  end

  # POST /calculates
  # POST /calculates.json
  def create
    @calculate  = Calculate.new(calculate_params)
    @calculate.created_by     = current_user.id
    @calculate.updated_by     = current_user.id

    respond_to do |format|
      if @calculate.save
        format.html { redirect_to @calculate}
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
    @calculate.updated_by     = current_user.id    
    
    respond_to do |format|
      if @calculate.update(calculate_params)
        format.html { redirect_to @calculate, notice: 'Calculo editado exitosamente.' }
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
      params.require(:calculate).permit(:product_id, :qty)
    end
end
