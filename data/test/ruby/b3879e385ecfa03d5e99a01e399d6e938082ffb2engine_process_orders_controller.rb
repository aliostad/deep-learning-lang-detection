class EngineProcessOrdersController < ApplicationController
  def index
    @engine_process_orders = EngineProcessOrder.all
  end

  def show
    @engine_process_order = EngineProcessOrder.find(params[:id])
  end

  def new
    @engine_process_order = EngineProcessOrder.new
  end

  def create
    @engine_process_order = EngineProcessOrder.new(params[:engine_process_order])
    if @engine_process_order.save
      redirect_to @engine_process_order, :notice => "Successfully created engine process order."
    else
      render :action => 'new'
    end
  end

  def edit
    @engine_process_order = EngineProcessOrder.find(params[:id])
  end

  def update
    @engine_process_order = EngineProcessOrder.find(params[:id])
    if @engine_process_order.update_attributes(params[:engine_process_order])
      redirect_to @engine_process_order, :notice  => "Successfully updated engine process order."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @engine_process_order = EngineProcessOrder.find(params[:id])
    @engine_process_order.destroy
    redirect_to engine_process_orders_url, :notice => "Successfully destroyed engine process order."
  end
end
