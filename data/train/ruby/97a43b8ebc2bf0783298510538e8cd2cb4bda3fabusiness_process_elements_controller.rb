class BusinessProcessElementsController < ApplicationController
  before_filter :find_business_process

  def index
    @business_process_elements = @business_process.business_process_elements.all
  end

  def show
    @business_process_element = @business_process.business_process_elements.find(params[:id])
  end

  def new
    @business_process_element = @business_process.business_process_elements.new
  end

  def create
    @business_process_element = @business_process.business_process_elements.new(params[:business_process_element])
    if @business_process_element.save
      flash[:notice] = "Successfully created business process element."
      redirect_to [@business_process, @business_process_element]
    else
      render :action => 'new'
    end
  end

  def edit
    @business_process_element = @business_process.business_process_elements.find(params[:id])
  end

  def update
    @business_process_element = @business_process.business_process_elements.find(params[:id])
    if @business_process_element.update_attributes(params[:business_process_element])
      flash[:notice] = "Successfully updated business process element."
      redirect_to [@business_process, @business_process_element]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @business_process_element = @business_process.business_process_elements.find(params[:id])
    @business_process_element.destroy
    flash[:notice] = "Successfully destroyed business process element."
    redirect_to business_process_business_process_elements_url
  end

  private
    def find_business_process
        @business_process = BusinessProcess.find(params[:business_process_id])
    end
end
