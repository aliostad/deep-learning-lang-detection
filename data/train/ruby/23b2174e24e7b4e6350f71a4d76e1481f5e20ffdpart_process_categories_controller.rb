class PartProcessCategoriesController < ApplicationController
  # GET /part_process_categories
  # GET /part_process_categories.json
  def index
    @part_process_categories = PartProcessCategory.order(:sort_priority)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @part_process_categories }
    end
  end

  # GET /part_process_categories/1
  # GET /part_process_categories/1.json
  def show
    @part_process_category = PartProcessCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @part_process_category }
    end
  end

  # GET /part_process_categories/new
  # GET /part_process_categories/new.json
  def new
    @part_process_category = PartProcessCategory.new

    respond_to do |format|
      format.html do
        render :layout => false if params[:no_layout]
      end
      format.json { render json: @part_process_category }
    end
  end

  # GET /part_process_categories/1/edit
  def edit
    @part_process_category = PartProcessCategory.find(params[:id])

    respond_to do |format|
      format.html do
        render :layout => false if params[:no_layout]
      end
      format.json { render json: @part_process_category }
    end
  end

  # POST /part_process_categories
  # POST /part_process_categories.json
  def create
    @part_process_category = PartProcessCategory.new(params[:part_process_category])

    respond_to do |format|
      if @part_process_category.save
        format.html { redirect_to @part_process_category, notice: 'Part process category was successfully created.' }
        format.js
      else
        format.html { render action: "new" }
        format.js
      end
    end
  end

  # PUT /part_process_categories/1
  # PUT /part_process_categories/1.json
  def update
    @part_process_category = PartProcessCategory.find(params[:id])

    respond_to do |format|
      if @part_process_category.update_attributes(params[:part_process_category])
        format.html { redirect_to @part_process_category, notice: 'Part process category was successfully updated.' }
        format.js
      else
        format.html { render action: "edit" }
        format.js
      end
    end
  end

  # DELETE /part_process_categories/1
  # DELETE /part_process_categories/1.json
  def destroy
    @part_process_category = PartProcessCategory.find(params[:id])
    @part_process_category.destroy

    respond_to do |format|
      format.html { redirect_to part_process_categories_url }
      format.json { head :no_content }
    end
  end

  def update_part_process_category
    @part_process_category = PartProcessCategory.find(params[:id])
    @part_process_category[params[:field]] = params[:new_value]
    @part_process_category.save
  end

  def set_sort_priority
    count = 0
    params[:ids].each do |id|
      count += 1
      PartProcessCategory.update_all({:sort_priority => count}, {:id => id})
    end
  end
end
