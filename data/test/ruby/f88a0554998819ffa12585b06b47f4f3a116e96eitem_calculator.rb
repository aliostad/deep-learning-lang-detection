module ItemCalculator

  def self.calculate(transaction)
    ItemCalculator.calculateTraderQuantity(transaction)
    ItemCalculator.calculatePlayerQuantity(transaction)
    transaction
  end

  def self.calculateTraderQuantity(transaction)
    quantityChange = transaction.quantityChange
    transaction.traderInventoryItem.quantity += quantityChange
    transaction.updatedTraderQuantities << transaction.traderInventoryItem
  end

  def self.calculatePlayerQuantity(transaction)
    quantityChange = transaction.quantityChange * -1
    transaction.playerInventoryItem.quantity += quantityChange
    transaction.updatedPlayerQuantities << transaction.playerInventoryItem
  end

end