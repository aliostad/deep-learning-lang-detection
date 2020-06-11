class ProcessClassesController < ApplicationController
  load_and_authorize_resource

  def create
    if @process_class.save
      redirect_to @process_class, notice: t('notice.process_class.created')
    else
      render action: "new"
    end
  end

  def update
    if @process_class.update_attributes(params[:process_class])
      redirect_to @process_class, notice: t('notice.process_class.updated')
    else
      render action: "edit"
    end
  end

  def destroy
    begin
      @process_class.destroy
      flash[:success] = t('notice.process_class.destroyed')
    rescue ActiveRecord::DeleteRestrictionError => e
      @process_class.errors.add(:base, e)
      flash[:error] = t('exception.' + "#{e}")
    ensure
      redirect_to process_classes_url
    end
  end

  def index
    @process_classes = ProcessClass.where(company_id: current_company.id)
  end
end