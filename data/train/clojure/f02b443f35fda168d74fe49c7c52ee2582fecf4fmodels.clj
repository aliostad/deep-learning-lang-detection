(ns centipair.store.models
  (:use korma.core
        centipair.core.db.connection
        centipair.site.settings))

(defentity store_settings)
(defentity product_type)
(defentity product_type_attribute)
(defentity product_type_attribute_value)


(defn insert-store-settings [site-settings-data]
  (insert store_settings
          (values {:site_settings_id (:site_settings_id site-settings-data)
                   :store_name "Centipair store"
                   :store_description "Store description"
                   :store_base "US"
                   :default_currency "USD"
                   :enable_coupons false
                   :enable_guest_checkout true
                   :enable_customer_note true
                   :registration_on_checkout true
                   :default_product_sorting "popularity"
                   :shop_display_page "products"
                   :items_per_page 15
                   :product_rating false
                   :review_rating_required false
                   :show_verified_buyer_label true
                   :only_verified_buyer_review false
                   :review_alert_mail false
                   :currency_position "left"
                   :remove_trailing_zeros true
                   :catalog_images_width 150
                   :catalog_images_height 150
                   :catalog_images_hard_crop true
                   :single_product_image_width 150
                   :single_product_image_height 150
                   :single_product_image_hard_crop false
                   :product_thumbnails_width 150
                   :product_thumbnails_height 150
                   :product_thumbnails_hard_crop true
                   :manage_stock true
                   :hold_stock 60
                   :low_stock_notification true
                   :out_of_stock_notification true
                   :stock_notification_recipient ""
                   :low_stock_threshold 2
                   :out_of_stock_threshold 0
                   :out_of_stock_visibility true
                   :stock_display_format "only-low"
                   :enable_taxes false,
                   :tax_included_price false
                   :calculate_tax_based_on "shop-address"
                   :default_customer_address "none"
                   :shipping_tax_class "standard"
                   :tax_total_rounding false
                   :checkout_display_tax_price true
                   })))

(defn init-store-settings
  "Execute this only once"
  []
  (let [site-settings-data (first (get-all-sites))]
    (insert-store-settings site-settings-data)))


(defn select-store-settings
  "gets store settings"
  [site-settings-id]
  (first (select store_settings (where {:site_settings_id (Integer. site-settings-id)}))))
  

(defn select-all-stores
  []
  (select store_settings ))


(defn insert-store-settings
  ""
  [params]
   (insert store_settings
          (values {:site_settings_id (:site-settings-id params)
                   :store_name (:store-name params)
                   :store_description (:store-description params)
                   :store_base (:store-base params)
                   :default_currency (:default-currency params)
                   :enable_coupons (:enable-coupons params)
                   :enable_guest_checkout (:enable-guest-checkout params)
                   :enable_customer_note (:enable-customer-note params)
                   :registration_on_checkout (:registration-on-checkout params)
                   })))

(defn update-store-settings
  ""
  [params]
   (update store_settings
          (set-fields {:site_settings_id (:site-settings-id params)
                       :store_name (:store-name params)
                       :store_description (:store-description params)
                       :store_base (:store-base params)
                       :default_currency (:default-currency params)
                       :enable_coupons (:enable-coupons params)
                       :enable_guest_checkout (:enable-guest-checkout params)
                       :enable_customer_note (:enable-customer-note params)
                       :registration_on_checkout (:registration-on-checkout params)
                       })
          (where {:site_settings_id (:site-settings-id params)})))


(defn insert-catalog-settings
  [params]
  (insert store_settings 
          (values {:site_settings_id (:site-settings-id params)
                   :default_product_sorting (:default-product-sorting params)
                   :shop_display_page (:shop-display-page params)
                   :items_per_page (:items-per-page params)
                   :product_rating (:product-rating params)
                   :review_rating_required (:review-rating-required params)
                   :show_verified_buyer_label (:show-verified-buyer-label params)
                   :only_verified_buyer_review (:only-verified-buyer-review params)
                   :review_alert_mail (:review-alert-mail params)
                   :currency_position (:currency-position params)
                   :remove_trailing_zeros (:remove-trailing-zeros params)
                   :catalog_images_width (:catalog-images-width params)
                   :catalog_images_height (:catalog-images-height params)
                   :catalog_images_hard_crop (:catalog-images-hard-crop params)
                   :single_product_image_width (:single-product-image-width params)
                   :single_product_image_height (:single-product-image-height params)
                   :single_product_image_hard_crop (:single-product-image-hard-crop params)
                   :product_thumbnails_width (:product-thumbnails-width params)
                   :product_thumbnails_height (:product-thumbnails-height params)
                   :product_thumbnails_hard_crop (:product-thumbnails-hard-crop params)})))


(defn update-catalog-settings
  [params]
  (update store_settings 
          (set-fields {:default_product_sorting (:default-product-sorting params)
                       :shop_display_page (:shop-display-page params)
                       :items_per_page (:items-per-page params)
                       :product_rating (:product-rating params)
                       :review_rating_required (:review-rating-required params)
                       :show_verified_buyer_label (:show-verified-buyer-label params)
                       :only_verified_buyer_review (:only-verified-buyer-review params)
                       :review_alert_mail (:review-alert-mail params)
                       :currency_position (:currency-position params)
                       :remove_trailing_zeros (:remove-trailing-zeros params)
                       :catalog_images_width (:catalog-images-width params)
                       :catalog_images_height (:catalog-images-height params)
                       :catalog_images_hard_crop (:catalog-images-hard-crop params)
                       :single_product_image_width (:single-product-image-width params)
                       :single_product_image_height (:single-product-image-height params)
                       :single_product_image_hard_crop (:single-product-image-hard-crop params)
                       :product_thumbnails_width (:product-thumbnails-width params)
                       :product_thumbnails_height (:product-thumbnails-height params)
                       :product_thumbnails_hard_crop (:product-thumbnails-hard-crop params)})
          (where {:site_settings_id (:site-settings-id params)})))


(defn insert-inventory-settings [params]
  (insert store_settings
          (values {:site_settings_id (:site-settings-id params)
                   :manage_stock (:manage-stock params)
                   :hold_stock (:hold-stock params)
                   :low_stock_notification (:low-stock-notification params)
                   :out_of_stock_notification (:out-of-stock-notification params)
                   :stock_notification_recipient (:stock-notification-recipient params)
                   :low_stock_threshold (:low-stock-threshold params)
                   :out_of_stock_threshold (:out-of-stock-threshold params)
                   :out_of_stock_visibility (:out-of-stock-visibility params)
                   :stock_display_format (:stock-display-format params)})))


(defn update-inventory-settings [params]
  (update store_settings
          (set-fields {:manage_stock (:manage-stock params)
                      :hold_stock (:hold-stock params)
                      :low_stock_notification (:low-stock-notification params)
                      :out_of_stock_notification (:out-of-stock-notification params)
                      :stock_notification_recipient (:stock-notification-recipient params)
                      :low_stock_threshold (:low-stock-threshold params)
                      :out_of_stock_threshold (:out-of-stock-threshold params)
                      :out_of_stock_visibility (:out-of-stock-visibility params)
                      :stock_display_format (:stock-display-format params)})
          (where {:site_settings_id (:site-settings-id params)})))



(defn insert-tax-settings [params]
  (insert store_settings
          (values {:enable_taxes (:enable-taxes params)
                   :tax_included_price (:tax-included-price params)
                   :calculate_tax_based_on (:calculate-tax-based-on params)
                   :default_customer_address (:default-customer-address params)
                   :shipping_tax_class (:shipping-tax-class params)
                   :tax_total_rounding (:tax-total-rounding params)
                   :checkout_display_tax_price (:checkout-display-tax-price params)
                   :site_settings_id (:site-settings-id params)})))


(defn update-tax-settings [params]
  (update store_settings
          (set-fields {:enable_taxes (:enable-taxes params)
                       :tax_included_price (:tax-included-price params)
                       :calculate_tax_based_on (:calculate-tax-based-on params)
                       :default_customer_address (:default-customer-address params)
                       :shipping_tax_class (:shipping-tax-class params)
                       :tax_total_rounding (:tax-total-rounding params)
                       :checkout_display_tax_price (:checkout-display-tax-price params)
                       :site_settings_id (:site-settings-id params)})
          (where {:site_settings_id (:site-settings-id params)})))
;;Product type functions


(defn get-product-type
  "get product type from name"
  [product-type-name]
  (first ( select product_type (where {:product_type_name product-type-name}))))

(defn get-product-type-id
  "get product type from id"
  [product-type-id]
  (first ( select product_type (where {:product_type_id product-type-id}))))


(defn get-product-type-attribute
  "get product type from attribute name and product type id"
  [product-type-attribute-name product-type-id]
  (select product_type (where {:product_type_attribute_name product-type-attribute-name :product_type_id product-type-id})))


(defn unique-product-type?
  "Checks whether the product type is unique"
  [product-type-name]
  (nil? (get-product-type product-type-name)))


(defn insert-product-type
  "inserts product type into db"
  [params]
  (insert product_type
          (values {:product_type_name (params :product-type-name)
                   :product_type_entity (params :product-type-entity)})))

(defn create-product-type
  "create product type"
  [params]
  (let [product-type (get-product-type (:product-type-name params))]
    (if (nil? product-type)
      (insert-product-type params)
      product-type)))


(defn insert-product-type-attribute
  "insert product type attribute into db"
  [params]
  (insert product_type_attribute
          (values {:product_type_id (:product-type-id params)
                   :product_type_attribute_name (:product-type-attribute-name params)
                   :product_type_attribute_sort_order (:product-type-attribute-sort-order params)})))


(defn create-product-type-attribute
  "creates product type attirbute.if product type is not found return 404"
  [params]
  (let [product-type (get-product-type (:product-type-id params))]
    (if (nil? product-type)
      {:status-code 404 :message "Product Type Not Found"}
      (insert-product-type-attribute params))))
