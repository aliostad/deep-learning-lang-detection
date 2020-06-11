class InventoryManagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_librarian

  def index
    @inventory_manages = InventoryManage.all
    prepare_option

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inventory_manages }
    end
  end

  def show
    @inventory_manage = InventoryManage.find(params[:id])
    @inventory_notifications = @inventory_manage.phase1_check
    @inventory_check_errors = []
    @inventory_manage.check_has_error?
    if InventoryCheckResult.has_error?(params[:id])
      @inventory_check_errors << I18n.t("inventory_page.has_error_check_results")
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @inventory_manage }
    end
  end

  def new
    @inventory_manage = InventoryManage.new
    prepare_option

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @inventory_manage }
    end
  end

  def edit
    @inventory_manage = InventoryManage.find(params[:id])
    prepare_option
  end

  def create
    @inventory_manage = InventoryManage.new(params[:inventory_manage])
    prepare_option

    respond_to do |format|
      if @inventory_manage.save
        @inventory_manage.copy_shelves_to_inventory_shelves
        format.html { redirect_to @inventory_manage, notice: 'Inventory manage was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @inventory_manage = InventoryManage.find(params[:id])
    prepare_option

    respond_to do |format|
      if @inventory_manage.update_attributes(params[:inventory_manage])
        format.html { redirect_to @inventory_manage, notice: 'Inventory manage was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @inventory_manage = InventoryManage.find(params[:id])
    @inventory_manage.destroy

    respond_to do |format|
      format.html { redirect_to inventory_manages_url }
      format.json { head :no_content }
    end
  end

  def finish
    @inventory_manage = InventoryManage.find(params[:id])
    if InventoryCheckResult.has_error?(params[:id])
      @inventory_manage.errors[:base] << I18n.t("inventory_page.has_error_check_results")
    end
    prepare_option
  end

  def finished
    @inventory_manage = InventoryManage.find(params[:id])
    if @inventory_manage.finished
      redirect_to @inventory_manage, notice: 'Inventory manage was successfully updated.' 
    else
      render action: "finish" 
    end
  end

  private
  def prepare_option
    @manifestation_types = ManifestationType.all 
    @inventory_shelf_groups = InventoryShelfGroup.all || []
    @bind_types = ShelfBindType.all
  end
end

