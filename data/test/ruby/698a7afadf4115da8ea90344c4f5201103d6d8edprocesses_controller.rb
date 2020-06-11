class ProcessesController < ApplicationController

  def index
    @processes = Process.all
  end

  def show
    @process = Process.find_by_id(params[:id])
  end

  def new
    @process = Process.new
  end

  def create
    @process = Process.new
    @process.name = params[:name]
    @process.start_date = params[:start_date]
    
    if @process.save
            redirect_to processes_url
          else
      render 'new'
    end
  end

  def edit
    @process = Process.find_by_id(params[:id])
  end

  def update
    @process = Process.find_by_id(params[:id])
    @process.name = params[:name]
    @process.start_date = params[:start_date]
    
    if @process.save
            redirect_to processes_url
          else
      render 'edit'
    end
  end

  def destroy
    @process = Process.find_by_id(params[:id])
    @process.destroy
        redirect_to processes_url
      end
end
