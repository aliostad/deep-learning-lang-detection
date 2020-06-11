class ProcessAreasController < ApplicationController
  before_action :set_process_area, only: [:show]

  def index
    add_breadcrumb "Process Area Components", process_area_components_path
    add_breadcrumb "Process Areas"
    @process_areas = ProcessArea.all
  end

  def show
    add_breadcrumb "Process Area Components", process_area_components_path
    add_breadcrumb "Process Areas", process_areas_path
    add_breadcrumb @process_area.name
    @specific_goals = SpecificGoal.where(process_area_id: @process_area)
    @generic_goals = GenericGoal.all 
    @generic_practice_elaborations = GenericPracticeElaboration.where(process_area_id: @process_area)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_area
      @process_area = ProcessArea.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def process_area_params
      params.require(:process_area).permit(:name, :purpose, :maturity_level_id, :process_category_id)
    end
end
