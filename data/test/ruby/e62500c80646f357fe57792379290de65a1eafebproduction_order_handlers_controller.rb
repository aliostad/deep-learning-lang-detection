class ProductionOrderHandlersController < ApplicationController
  before_action :set_production_order_handler, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @production_order_handlers = ProductionOrderHandler.all
    respond_with(@production_order_handlers)
  end

  def show
    respond_with(@production_order_handler)
  end

  def new
    @production_order_handler = ProductionOrderHandler.new
    respond_with(@production_order_handler)
  end

  def edit
  end

  def create
    @production_order_handler = ProductionOrderHandler.new(production_order_handler_params)
    @production_order_handler.save
    respond_with(@production_order_handler)
  end

  def update
    @production_order_handler.update(production_order_handler_params)
    respond_with(@production_order_handler)
  end

  def destroy
    @production_order_handler.destroy
    respond_with(@production_order_handler)
  end

  private
    def set_production_order_handler
      @production_order_handler = ProductionOrderHandler.find(params[:id])
    end

    def production_order_handler_params
      params.require(:production_order_handler).permit(:nr, :desc, :remark)
    end
end
