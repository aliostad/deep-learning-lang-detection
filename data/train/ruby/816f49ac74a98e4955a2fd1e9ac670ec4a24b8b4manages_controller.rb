class ManagesController < ApplicationController
  before_action :authenticate_user!
  before_filter :admin_only

  def index
    @manages = Booking.all
  end

  def show
    @manage = Booking.find(params[:id])
    if @manage
      render
    else
      redirect_to manages_path, notice: "Oopss! Booking not found!"
    end
  end

  def set_close
    @manage = Booking.find(params[:id])
    @manage.update_attributes(status: 1)
    redirect_to manages_path
  end

  def set_active
    @manage = Booking.find(params[:id])
    @manage.update_attributes(status: 0)
    redirect_to manages_path
  end
end
