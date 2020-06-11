class BatchHopperLot < ActiveRecord::Base
  belongs_to :hopper_lot
  belongs_to :batch

  validates_uniqueness_of :batch_id, :scope => [:hopper_lot_id]
  validates_associated :batch, :hopper_lot
  validates_numericality_of :amount, :greater_than_or_equal_to => 0

  after_save :calculate_incr
  after_destroy :calculate_decr

  def calculate_incr
    puts "amount: #{self.amount}"
    b = Batch.find self.batch_id
    #b.total += self.amount
    b.save
  end

  def calculate_decr
    b = Batch.find self.batch_id
    #b.total -= self.amount
    b.save
  end
end
