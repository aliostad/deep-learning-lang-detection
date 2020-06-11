class Api::CustomersController < ApplicationController
  before_action :set_api_customer, only: [:show, :update, :destroy]

  # GET /api/customers
  # GET /api/customers.json
  def index
    @api_customers = Api::Customer.all

    render json: @api_customers
  end

  # GET /api/customers/1
  # GET /api/customers/1.json
  def show
    render json: @api_customer
  end

  # POST /api/customers
  # POST /api/customers.json
  def create
    @api_customer = Api::Customer.new(api_customer_params)

    if @api_customer.save
      render json: @api_customer, status: :created, location: @api_customer
    else
      render json: @api_customer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/customers/1
  # PATCH/PUT /api/customers/1.json
  def update
    @api_customer = Api::Customer.find(params[:id])

    if @api_customer.update(api_customer_params)
      head :no_content
    else
      render json: @api_customer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/customers/1
  # DELETE /api/customers/1.json
  def destroy
    @api_customer.destroy

    head :no_content
  end

  private

    def set_api_customer
      @api_customer = Api::Customer.find(params[:id])
    end

    def api_customer_params
      params.require(:api_customer).permit(:first_name, :last_name, :address1, :address2, :zip, :city, :state, :ssid, :email, :phone, :price)
    end
end
