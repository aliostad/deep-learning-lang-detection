class TagsController < ApplicationController
  authorize_resource

  before_filter :find_tag, only: [:edit, :update, :destroy]

  helper_method :manage?

  def index
    if manage?
      @tags = Tag.order(:name)
    end
  end

  def edit

  end

  def update
    if @tag.update_attributes params[:tag]
      redirect_to tags_path(manage: 1), notice: t(:updated_successfully)
    else
      render :edit
    end
  end

  def destroy
    @tag.destroy
    redirect_to tags_path(manage: 1)
  end

  def manage?
    params[:manage].present? && can?(:manage, Tag)
  end

  private
  def find_tag
    @tag = Tag.find params[:id]
  end
end
