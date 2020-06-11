class Manage::OrdersController < Manage::BaseController
  before_filter :find_order, :only => [:show, :pay, :ship, :void, :destroy, :resend_receipt]

  def index
    criteria = params[:search] ? params[:search] : {}  # { "conditions" => {"state"=>"pending"} }
    @search = Order.new_search(criteria)
    @orders, @order_count = @search.all, @search.count
  end

  def show
    @payment = @order.completed_payment
    @ipns = PaymentNotification.find_all_by_order_id(@order.id, :order => "created_at DESC")
  end

  def pay
    if @order.can_pay?
      @order.transaction do
        @order.update_attributes( {:note => t('checkout.common.payment_accept_msg') })
        @order.pay!
      end
      flash[:notice] = t("manage.orders.pay.success_msg")
    else
      flash[:notice] = t("manage.orders.pay.failed_msg")
    end
    redirect_to manage_order_path(@order)
  end

  def ship
    if @order.can_ship?
      @order.ship!
      flash[:notice] = t("manage.orders.ship.success_msg")
    else
      flash[:notice] = t("manage.orders.ship.failed_msg")
    end
    redirect_to manage_order_path(@order)
  end

  def void
    if @order.can_void?
      @order.void!
      flash[:notice] = t("manage.orders.void.success_msg")
    else
      flash[:notice] = t("manage.orders.void.failed_msg")
    end
    redirect_to manage_order_path(@order)
  end

  def destroy
    if @order.can_destroy?
      @order.destroy
      flash[:notice] = t("manage.orders.destroy.success_msg")
    else
      flash[:notice] = t("manage.orders.destroy.failed_msg")
    end
  rescue Exception => e
    flash[:notice] = t("manage.orders.destroy.failed_msg") << e.message
  ensure
    redirect_to manage_orders_path
  end

  def resend_receipt
    if ["pending","paid","shipped"].include?(@order.state)
      OrderMailer.deliver_receipt(@order, true)
      flash[:notice] = t("manage.orders.resend_receipt.success_msg")
    else
      flash[:notice] = t("manage.orders.resend_receipt.failed_msg")
    end
    redirect_to manage_order_path(@order)
  end

  private

  def find_order
    @order = Order.find(params[:id], :include => [:order_lines, :user])
  end
end
