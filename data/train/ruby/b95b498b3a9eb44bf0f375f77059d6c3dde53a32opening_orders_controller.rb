class Manage::OpeningOrdersController < Manage::InheritedResourcesController
  belongs_to :chair, :parent_class => Chair

  actions :new, :create, :update

  defaults instance_name: 'order'

  layout 'chair'

  def new
    new! { render 'manage/orders/new' and return }
  end

  def create
    create! do | success, failure |
      success.html { redirect_to manage_chair_order_path(@chair, resource) }
      failure.html { render 'manage/orders/new' }
    end
  end

  def update
    resource.actor = current_user.name
    update! do |success, failure|
      success.html { redirect_to manage_chair_order_path(@chair, resource) }
      failure.html { render resource.state_event ? 'manage/orders/show' : 'manage/orders/edit' }
    end
  end
end
