class ManageTypesController < ApplicationController
  authorize_resource :class => false

  def index
    @manage_types = Type.all
  end

  def new
    @manage_type = Type.new
  end

  def create
    @manage_type = Type.new(params[:type])
     
    if @manage_type.save
      redirect_to manage_types_path, notice: t('notice.succ_create', elem: Type.model_name.human)
    else
       render action: "new" 
    end
  end

  def destroy
    @manage_type = Type.find(params[:id])
    
    unless @manage_type.ads.empty?
      redirect_to manage_types_url, notice: t('type_not_empty') and return
    end

    @manage_type.destroy 
    redirect_to manage_types_url
  end

end