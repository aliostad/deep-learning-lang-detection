class Ordene < ActiveRecord::Base
  belongs_to :presupuesto
  belongs_to :medio
  belongs_to :proveedore
  has_one :factura_item, dependent: :destroy
  has_many :incentivos, dependent: :destroy
  has_many :orden_items
  
  after_initialize :calculate_subtotal, :calculate_iva, :calculate_total

  def calculate_subtotal
      self.subtotal = self.orden_items.sum(:subtotal)
  end   

  def calculate_iva
    self.iva = self.orden_items.sum(:iva)
  end
  
  def calculate_total
    self.total = subtotal + iva
  end
end
