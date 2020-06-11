class BusinessProcessesController < ApplicationController
  load_and_authorize_resource

  def create
    @business_process.created_by = current_user.id
    if @business_process.save
      redirect_to @business_process, notice: 'Business process was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @business_process.update_attributes(params[:business_process])
      redirect_to @business_process, notice: 'Business process was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @business_process.destroy
    redirect_to business_processes_url
  end
end
