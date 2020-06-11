###
# Describes which API URLs are used for collections and resources
#
# Consider this the definitive spec for what URL vending machine
# will be retrieving resources from.
#
require_relative 'spec_helper'

module Vend
  describe "Resource URLs" do
    extend UrlAssertions

    {
      Customer: {
        index: "/api/customers",
        show: "/api/1.0/customer/:id",
        create: "/api/customers",
        update: "/api/customers"
      },
      Inventory: {
        show: "/api/1.0/inventory/:id",
      },
      PaymentType: {
        index: "/api/payment_types"
      },
      ProductType: {
        show: "/api/1.0/product_type/:id"
      },
      Product: {
        index: "/api/products",
        show: "/api/1.0/product/:id",
        create: "/api/products",
        update: "/api/products",
        destroy: "/api/products/:id"
      },
      Sale: {
        index: "/api/register_sales",
        show: "/api/1.0/register_sale/:id",
        create: "/api/register_sales"
      },
      Supplier: {
        show: "/api/1.0/supplier/:id"
      },
      Register: {
        index: "/api/registers",
      },
      Tax: {
        index: "/api/taxes",
        create: "/api/taxes"
      },
      User: {
        index: "/api/users",
        show: "/api/1.0/user/:id"
      }
    }.each do |class_name, verb_routes|
      assert_resource_urls("Vend::#{class_name.to_s}".constantize, verb_routes)
    end
  end
end
