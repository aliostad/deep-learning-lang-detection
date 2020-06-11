class Admin::CalculateAnnotationsController < Admin::ApplicationController
  
  def index
    if params[:category] and params[:source]
      @calculates = CalculateAnnotation.where(category: params[:category], source: params[:source])
    else
      @calculates = nil
    end

    @category = params[:category]
    @source = params[:source]

    @sources = PostingConstants::SOURCES
    @categories = PostingConstants::CATEGORIES

    add_breadcrumb "index", admin_calculate_annotations_path
  end

  def update
    calculates_params.each do |calc_id, attrs|
      @calculate = CalculateAnnotation.find calc_id
      @calculate.update_attributes weight: attrs[:weight].to_i
    end
  ensure
    redirect_to admin_calculate_annotations_path(category: params[:category], source: params[:source])
  end

  private

  def calculates_params
    params.require(:calculates).permit!
  end
end
