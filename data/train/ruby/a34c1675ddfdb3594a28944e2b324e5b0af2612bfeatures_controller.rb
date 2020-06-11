class Manage::FeaturesController < Manage::ApplicationController
  load_and_authorize_resource

  def create
    create!{
      redirect_to manage_organization_category_path(@feature.organization_category) and return
    }
  end

  def update
    update!{
      redirect_to manage_organization_category_path(@feature.organization_category) and return
    }
  end

  def destroy
    destroy!{
      redirect_to manage_organization_category_path(@feature.organization_category) and return
    }
  end

  def build_resource
    @feature = OrganizationCategory.find(params[:organization_category_id]).features.new(params[:feature])
  end
end
