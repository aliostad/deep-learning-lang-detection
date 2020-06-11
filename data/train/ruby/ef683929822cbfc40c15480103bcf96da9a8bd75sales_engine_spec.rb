require 'spec_helper'

describe SalesEngine do
  let(:engine) { SalesEngine.new }

  describe ".new" do
    it "creates a new SalesEngine instance" do
      expect(engine).to be_an_instance_of SalesEngine
    end
  end

  describe "#merchant_repository" do
    it "returns an instance of MerchantRepository" do
      expect(engine.merchant_repository).to be_an_instance_of MerchantRepository
    end
  end

  describe "#invoice_repository" do
    it "returns an instance of InvoiceRepository" do
      expect(engine.invoice_repository).to be_an_instance_of InvoiceRepository
    end
  end

  describe "#item_repository" do
    it "returns an instance of ItemRepository" do
      expect(engine.item_repository).to be_an_instance_of ItemRepository
    end
  end

  describe "#customer_repository" do
    it "returns an instance of CustomerRepository" do
      expect(engine.customer_repository).to be_an_instance_of CustomerRepository
    end
  end
end
