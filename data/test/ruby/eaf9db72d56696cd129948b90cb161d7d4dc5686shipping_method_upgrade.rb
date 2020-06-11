module Spree
  class ShippingMethodUpgrade < Spree::Base
    belongs_to :shipping_method, class_name: 'Spree::ShippingMethod'
    belongs_to :shipping_upgrade, class_name: 'Spree::ShippingUpgrade'
    has_many :shipment_upgrades, dependent: :delete_all
    has_many :shipments, through: :shipment_upgrades

    def calculator(shipment)
      if shipping_upgrade_id == 1
        cost = calculate_package_insurance(shipment)
      elsif shipping_upgrade_id == 2
        cost = calculate_case_overbox
      elsif shipping_upgrade_id == 3
        cost = calculate_case_overbox
      end
      cost            
    end

    private
      def calculate_package_insurance(shipment)
        shipment.item_cost * calculated_value.to_i / 100
      end

      def calculate_case_overbox
        calculated_value.to_i
      end

      def calculate_adult_signature
        calculated_value.to_i
      end

  end
end
