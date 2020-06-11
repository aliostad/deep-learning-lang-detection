class AddCalculateBalanceStrategyTypes
  
  def self.up
    [
        ['Calculate with invoices and payments', 'invoices_and_payments'],
        ['Calculate with payments', 'payments'],
        ['Calculate with invoices items and payments', 'invoice_items_and_payments']
    ].each do |item|
      CalculateBalanceStrategyType.create(:description => item[0], :internal_identifier => item[1])
    end

  end
  
  def self.down
    ['invoices_and_payments','payments', 'invoice_items_and_payments'].each do |iid|
      CalculateBalanceStrategyType.destroy_all("internal_identifier = #{iid}")
    end
  end

end
