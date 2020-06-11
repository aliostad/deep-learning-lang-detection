unless Spree::Api::ApiHelpers.product_attributes.include?(:store_ids)
  Spree::Api::ApiHelpers.product_attributes << :store_ids
end

unless Spree::Api::ApiHelpers.product_attributes.include?(:tax_category_id)
  Spree::Api::ApiHelpers.product_attributes << :tax_category_id
end

unless Spree::Api::ApiHelpers.product_attributes.include?(:layout)
  Spree::Api::ApiHelpers.product_attributes << :layout
end

unless Spree::Api::ApiHelpers.image_attributes.include?(:option_value_id)
  Spree::Api::ApiHelpers.image_attributes << :option_value_id
end
