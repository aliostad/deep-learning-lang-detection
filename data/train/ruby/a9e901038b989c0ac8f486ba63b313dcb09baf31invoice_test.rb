require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  test "generate_id" do 
    invoice = Invoice.new
    assert_equal(invoice.invoice_no, 'IN003') 
  end

  test "calculate_total" do 
    invoice = invoices(:invoice_1)
    assert_equal(100, invoice.total)
  end

  test "calculate_payment" do 
    invoice = invoices(:invoice_1)
    assert_equal(10, invoice.pay_total)
  end

  test "calculate_remain" do 
    invoice = invoices(:invoice_1)
    assert_equal(90, invoice.calculate_remain)
  end

end
