(ns centipair.store.forms
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [centipair.core.components.input :as input]
            [centipair.core.components.tabs :as tabs]
            [centipair.core.utilities.validators :as v]
            [centipair.core.utilities.ajax :as ajax]
            [centipair.core.utilities.countries :as co]
            [centipair.core.utilities.currency :as cu]
            [centipair.core.ui :as ui]
            [cljs.core.async :refer [put! chan <!]]
            [reagent.core :as reagent :refer [atom]]
            [centipair.admin.channels :refer [store-settings-channel
                                              site-settings-id
                                              set-active-channel]]
            [centipair.admin.resources :refer [store-source]]))

(def store-settings-id (atom {:id "store-settings-id" :value nil} ))
(def store-name (atom {:id "store-name" :type "text" :label "Store Name" :validator v/required} ))
(def store-description (atom {:id "store-description" :type "textarea" :label "Store Description" 
                              :validator v/required}))
(def store-base (atom {:id "store-base" :type "select" :label "Store Base" 
                       :options co/supported-country-list :value "US"}))
(def default-currency (atom {:id "default-currency" :type "select" :label "Default Currency" 
                             :options cu/supported-currency-list :value "USD"}))
(def cart-account-subheading (atom {:id "cart-account" :label "Cart, Checkout and Accounts" 
                                    :type "subheading"}))
(def enable-coupons (atom {:id "enable-coupons" :label "Coupons" :type "checkbox" 
                           :description "Enable the use of coupons"}))
(def enable-guest-checkout (atom {:id "enable-guest-checkout" :label "Checkout" :type "checkbox" 
                                  :description "Enable Guest Checkout"}))
(def enable-customer-note (atom {:id "enable-customer-note" :label "" :type "checkbox" 
                                 :description "Enable Customer Note on Checkout"}))
(def registration-on-checkout (atom {:id "registration-on-checkout" :label "Registration" 
                                     :type "checkbox" :description "Allow registration on checkout"}))

(def default-product-sorting (atom {:id "product-sorting" :type "select" :label "Default product sorting"
                                    :options [{:label "Popularity (sales)" :value "popularity"}
                                              {:label "Average Rating" :value "rating"}
                                              {:label "Sort by most recent" :value "recent"}
                                              {:label "Sort by Price (ascending)" :value "price-ascending"}
                                              {:label "Sort by Price (descending)" :value "price-descending"}
                                              ]}))

(def shop-display-page (atom {:id "shop-display-page" :type "select" :label "Shop Display"
                              :options [{:label "Show products" :value "products"}
                                        {:label "categories" :value "categories"}
                                        {:label "both" :value "both"}
                                       ]}))


(defn validate-items-per-page
  ""
  [field]
  (let [check-value (js/parseInt (:value field))]
    (if (integer? check-value)
      (if (< (:value field) 100)
        (v/validation-success)
        {:message "Please enter an integer less than 100"
         :valid false})
      {:message "Please enter an integer less than 100"
       :valid false})))


(def items-per-page (atom {:id "items-per-page" :label "Number of items per page" 
                           :type "text" :size 1 :validator validate-items-per-page
                           :value-type "integer"}))

(def product-subheading (atom {:id "product-subheading" :label "Product" :type "subheading"}))

(def weight-unit (atom {:id "weight-unit" :label "Weight Unit" :type "select" 
                        :options [{:label "Kilogram (kg)" :value "kg"}
                                  {:label "Gram (g)" :value "g"}
                                  {:label "Pound (lbs)" :value "lbs"}
                                  {:label "Ounce (oz)" :value "oz"}
                                  ]}))

(def dimensions-unit (atom {:id "dimensions-unit" :label "Dimensions Unit" :type "select"
                            :options [{:label "Meter (m)" :value "m"}
                                      {:label "Centimeter (m)" :value "cm"}
                                      {:label "Millimeter (mm)" :value "mm"}
                                      {:label "Inch (in)" :value "in"}
                                      {:label "Yard (yd)" :value "yd"}]
                            }))
(def product-rating (atom {:id "product-rating" :label "Product Ratings" 
                           :type "checkbox" :description "Enable product ratings"}))
(def review-rating-required (atom {:id "review-rating-required" :label "" 
                                   :type "checkbox" :description "Ratings are required to leave a review"}))
(def show-verified-buyer-label (atom {:id "show-verified-buyer-label" :label "" 
                                      :type "checkbox" :description "Show 'Verified Buyer' label"}))
(def only-verified-buyer-review (atom {:id "only-verified-buyer-review" :label "" 
                                       :type "checkbox" 
                                       :description "Only allow reviews from verified buyers"}))
(def review-alert-mail (atom {:id "review-alert-mail" 
                              :label "New Review Alert Mail" :type "checkbox" 
                              :description "Send an email to admin when new review is submitted"}))
(def pricing-subheading (atom {:id "pricing-subheading" :label "Pricing" 
                               :type "subheading" :description "Product based settings"}))

(def currency-position (atom {:id "currency-position" :label "Currency position" :type "select"
                              :options [{:label "Left" :value "left"}
                                        {:label "Right" :value "right"}
                                        {:label "Left (with space)" :value "left-space"}
                                        {:label "Right (with space)" :value "right-space"}
                                        ]}))

(def remove-trailing-zeros (atom {:id "remove-trailing-zeros" 
                                  :label "Trailing zeros" :type "checkbox" 
                                  :description "Remove trailing zeros after the decimal point. e.g. $10.00 becomes $10"}))

(def product-image-subheading (atom {:id "product-image-subheading" 
                                     :label "Product Image Sizes" :type "subheading"
                                     :description "These settings affect the actual dimensions of images in your catalog - the display on the front-end will still be affected by CSS styles"}))

(defn validate-image-specs [field])

(def catalog-images (atom {:id "catalog-images" :type "image-spec" 
                           :label "Catalog Images"
                           :width {:id "catalog-images-width"}
                           :height {:id "catalog-images-height"}
                           :crop {:id "catalog-images-hard-crop" :description "hard crop"}
                           }))

(def single-product-image (atom {:id "single-product-image" :type "image-spec" :label "Single product image"
                           :width {:id "single-product-image-width" }
                           :height {:id "single-product-image-height"}
                           :crop {:id "single-product-image-hard-crop" :description "hard crop"}
                           }))

(def product-thumbnails (atom {:id "product-thumbnails" :type "image-spec" :label "Product thumbnails"
                           :width {:id "product-thumbnails-width" }
                           :height {:id "product-thumbnails-height"}
                           :crop {:id "product-thumbnails-hard-crop" :description "hard crop"}
                           }))


(def manage-stock (atom {:id "manage-stock" :label "Manage Stock" :type "checkbox"
                         :description "Enable stock management"}))
(def hold-stock (atom {:id "hold-stock" :label "Hold Stock (minutes)" :type "text" :size 1 :validator v/integer-required :value-type "integer"}))
(def low-stock-notification (atom {:id "low-stock-notification" :type "checkbox"
                                   :label "Notifications" :description "Enable low stock notification"}))
(def out-of-stock-notification (atom {:id "out-of-stock-notification" :type "checkbox" :label "" :description "Enable out of stock notification"}))

(def stock-notification-recipient (atom {:id "stock-notification-recipient" :type "email" 
                                         :label "Notification recipient"
                                         :placeholder "Enter stock notification recipient email"
                                         :validator v/email-required }))

(def low-stock-threshold (atom {:id "low-stock-threshold" :type "text" :label "Low stock threshold" :size 1 :value-type "integer"}))
(def out-of-stock-threshold (atom {:id "out-of-stock-threshold" :type "text"
                                   :label "Out of stock threshold" :size 1 :value-type "integer" :validator v/integer-required}))

(def out-of-stock-visibility (atom {:id "out-of-stock-visibility" :type "checkbox" :label "Out of stock visibility" :description "Hide out of stock items from the catalog"}))

(def stock-display-format (atom {:id "stock-display-format" :label "Stock display format" :type "select"
                                 :options [{:label "Always show stock e.g. \"9 in stock\"" :value "always"}
                                           {:label "Only show stock when low e.g. \"only 2 left in stock\" vs \"In stock\"" :value "only-low"}
                                           {:label "Never show stock amount" :value "never"}
                                           ]}))

(def store-form (atom {:title "Store Settings" :id "store-form" :type "form"}))

(def catalog-form (atom {:title "Catalog Settings" :id "catalog-settings" :type "form"}))

(def inventory-form (atom {:title "Inventory Options" :id "inventory-options" :type "form"}))


(def store-group (atom {:id "group" :value "store"}))
(defn save-store-settings []
  (ajax/form-post 
   store-form
   (store-source (:value @store-settings-id))
   [store-group
    site-settings-id
    store-settings-id
    store-name
    store-description
    store-base
    default-currency
    enable-coupons
    enable-guest-checkout
    enable-customer-note
    registration-on-checkout
    ]
   (fn [response]
     (do 
       (put! store-settings-channel (:site_settings_id response))
       (ajax/data-saved-notifier response)))))

(def save-store-button (atom {:label "Save" :on-click save-store-settings :id "save-store-button"} ))



(defn create-store-form []
  (input/form-aligned store-form [store-name
                                  store-description
                                  store-base
                                  default-currency
                                  cart-account-subheading
                                  enable-coupons
                                  enable-guest-checkout
                                  enable-customer-note
                                  registration-on-checkout
                                  ] save-store-button))

(def catalog-group (atom {:id "group" :value "catalog"}))
(defn save-catalog-settings []
  (ajax/form-post
   catalog-form
   (store-source (:value @store-settings-id))
   [catalog-group
    default-product-sorting
    shop-display-page
    items-per-page
    product-subheading
    weight-unit
    dimensions-unit
    product-rating
    review-rating-required
    show-verified-buyer-label
    only-verified-buyer-review
    review-alert-mail
    pricing-subheading
    currency-position
    remove-trailing-zeros
    product-image-subheading
    catalog-images
    single-product-image
    product-thumbnails
    site-settings-id
    store-settings-id]
   (fn [response]
     (swap! store-settings-id assoc :value (:store_settings_id response))
     )))

(def save-catalog-button (atom {:label "Save" :on-click save-catalog-settings :id "save-catalog-button"}))

(defn create-catalog-form []
  (input/form-aligned catalog-form [default-product-sorting
                                    shop-display-page
                                    items-per-page
                                    product-subheading
                                    weight-unit
                                    dimensions-unit
                                    product-rating
                                    review-rating-required
                                    show-verified-buyer-label
                                    only-verified-buyer-review
                                    review-alert-mail
                                    pricing-subheading
                                    currency-position
                                    remove-trailing-zeros
                                    product-image-subheading
                                    catalog-images
                                    single-product-image
                                    product-thumbnails
                                    ] save-catalog-button))

(def inventory-group (atom {:id "group" :value "inventory"}))
(defn save-inventory []
  (ajax/form-post
   inventory-form
   (store-source (:value @store-settings-id))
   [inventory-group
    manage-stock
    hold-stock
    low-stock-notification
    out-of-stock-notification
    stock-notification-recipient
    low-stock-threshold
    out-of-stock-threshold
    out-of-stock-visibility
    stock-display-format
    site-settings-id
    store-settings-id]
   (fn [response]
     (swap! store-settings-id assoc :value (:store_settings_id response)))))

(def save-inventory-button (atom {:label "Save" :on-click save-inventory :id "save-inventory-button"}))

(defn create-inventory-form []
  (input/form-aligned inventory-form [manage-stock
                                      hold-stock
                                      low-stock-notification
                                      out-of-stock-notification
                                      stock-notification-recipient
                                      low-stock-threshold
                                      out-of-stock-threshold
                                      out-of-stock-visibility
                                      stock-display-format
                                      ] save-inventory-button))


(def enable-taxes (atom {:id "enable-taxes" :type "checkbox" :label "Enable Tax"
                         :description "Enable taxes and tax calculations"}))
(def tax-included-price (atom {:id "tax-included-price" :type "checkbox"
                               :label "Prices Entered With Tax"
                               :description "I will enter prices inclusive of tax"}))
(def calculate-tax-based-on (atom {:id "calculate-tax-based-on" :label "Calculate Tax based on" :type "select"
                                   :options [{:label "Customer Shipping Address"
                                              :value "customer-shipping-address"}
                                             {:label "Customer Billing Address"
                                              :value "customer-billing-address"}
                                             {:label "Shop Base Address" :value "shop-base-address"}]}))

(def default-customer-address (atom {:id "default-customer-address" :label "Default Customer Address" 
                                     :type "select"
                                     :options [{:label "Shop Base Address" :value "shop-base-address"}
                                               {:label "No Address" :value "none"}]}))

(def shipping-tax-class (atom {:id "shipping-tax-class" :label "Shipping Tax Class" :type "select"
                               :options [{:label "Shipping tax class based on cart items" :value "cart-items"}
                                         {:label "Standard" :value "standard"}
                                         {:label "Reduced Rate" :value "reduced-rate"}
                                         {:label "Zero Rate" :value "zero-rate"}]}))


(def tax-total-rounding (atom {:id "tax-total-rounding" :type "checkbox" :label "Rounding"
                               :description "Round tax at subtotal level, instead of rounding per line"}))
(def checkout-display-tax-price  (atom {:id "checkout-display-tax-price"
                                        :label "Display prices during cart/checkout" :type "select"
                                  :options [{:label "Excluding Tax" :value "excluding-tax"}
                                            {:label "Including Tax" :value "including-tax"}]}))
(def tax-form (atom {:title "Tax settings" :id "tax-settings"}))
(def tax-group (atom {:id "group" :value "tax"}))
(defn save-tax-settings []
  (ajax/form-post
   tax-form
   (store-source (:value @store-settings-id))
   [tax-group
    enable-taxes
    tax-included-price
    calculate-tax-based-on
    default-customer-address
    shipping-tax-class
    tax-total-rounding
    checkout-display-tax-price
    store-settings-id
    site-settings-id]
   (fn [response]
     (swap! store-settings-id assoc :value (:store_settings_id response)))))

(def save-tax-button (atom {:label "Save" :on-click save-tax-settings :id "save-tax-button"}))

(defn create-tax-form []
  (input/form-aligned tax-form [enable-taxes
                                tax-included-price
                                calculate-tax-based-on
                                default-customer-address
                                shipping-tax-class
                                tax-total-rounding
                                checkout-display-tax-price] save-tax-button))

 

(def store-settings-tab (atom {:id "store-settings" :label "Store Settings" 
                               :content create-store-form :active true :url "store-settings"}))
(def catalog-settings-tab (atom {:id "catalog-settings" :label "Catalog"
                                 :content create-catalog-form :active false :url "catalog-settings"}))
(def inventory-settings-tab (atom {:id "inventory-settings" :label "Inventory"
                                   :content create-inventory-form :active false :url "inventory-settings"}))
(def tax-settings-tab (atom {:id "tax-settings" :label "Tax" :content create-tax-form
                             :active false :url "tax-settings"}))

(defn settings-tabs []
  (tabs/render-tabs [store-settings-tab
                     catalog-settings-tab
                     inventory-settings-tab
                     tax-settings-tab
                     ]))


(def store-page (atom {:title "Store" :message "Loading store settings..."}))

(defn render-store-form
  [site-id]
  (do
    (set-active-channel store-settings-channel)
    (ui/render-page store-page settings-tabs)))


(defn load-store-message [response]
  (if (nil? (:store_settings_id response))
    (swap! store-page assoc :message "Store not found")
    (swap! store-page assoc :message "")))


(defn clear-store-form-errors []
  (input/clear-form-errors [store-form
                            store-name
                            store-description
                            store-base
                            default-currency
                            cart-account-subheading
                            enable-coupons
                            enable-guest-checkout
                            enable-customer-note
                            registration-on-checkout]))

(defn map-store-settings [response]    
    (do 
        (input/update-value store-settings-id (:store_settings_id response))
        (input/update-value store-name (:store_name response))
        (input/update-value store-description (:store_description response))
        (input/update-value store-base (:store_base response))
        (input/update-value default-currency (:default_currency response))
        (input/update-check enable-coupons (:enable_coupons response))
        (input/update-check enable-guest-checkout (:enable_guest_checkout response))
        (input/update-check enable-customer-note (:enable_customer_note response))
        (input/update-check registration-on-checkout (:registration_on_checkout response))
        (input/update-value default-product-sorting (:default_prouct_sorting response))
        (input/update-value shop-display-page (:shop_display_page response))
        (input/update-value items-per-page (:items_per_page response))
        (input/update-check product-rating (:product_rating response))
        (input/update-check review-rating-required (:review_rating_required response))
        (input/update-check show-verified-buyer-label (:show_verified_buyer_label response))
        (input/update-check only-verified-buyer-review (:only_verified_buyer_review response))
        (input/update-check review-alert-mail (:review_alert_mail response))
        (input/update-value currency-position (:currency_position response))
        (input/update-check remove-trailing-zeros (:remove_trailing_zeros response))
        (input/update-image-spec :width catalog-images (:catalog_images_width response))
        (input/update-image-spec :height catalog-images (:catalog_images_height response))
        (input/update-image-spec-check catalog-images (:catalog_images_hard_crop response))
        (input/update-image-spec :width single-product-image (:single_product_image_width response))
        (input/update-image-spec :height single-product-image (:single_product_image_height response))
        (input/update-image-spec-check single-product-image (:single_product_image_hard_crop response))
        (input/update-image-spec :width product-thumbnails (:product_thumbnails_width response))
        (input/update-image-spec :height product-thumbnails (:product_thumbnails_height response))
        (input/update-image-spec-check product-thumbnails (:product_thumbnails_hard_crop response))
        (input/update-check manage-stock (:manage_stock response))
        (input/update-value hold-stock (:hold_stock response))
        (input/update-check low-stock-notification (:low_stock_notification response))
        (input/update-check out-of-stock-notification (:out_of_stock_notification response))
        (input/update-value stock-notification-recipient (:stock_notification_recipient response))
        (input/update-value low-stock-threshold (:low_stock_threshold response))
        (input/update-value out-of-stock-threshold (:out_of_stock_threshold response))
        (input/update-check out-of-stock-visibility (:out_of_stock_visibility response))
        (input/update-value stock-display-format (:stock_display_format response))
        (input/update-check enable-taxes (:enable_taxes response))
        (input/update-check tax-included-price (:tax_included_price response))
        (input/update-value calculate-tax-based-on (:calculate_tax_based_on response))
        (input/update-value default-customer-address (:default_customer_address response))
        (input/update-value shipping-tax-class (:shipping_tax_class response))
        (input/update-check tax-total-rounding (:tax_total_rounding response))
        (input/update-value checkout-display-tax-price (:checkout_display_tax_price response))
        (load-store-message response)
        (clear-store-form-errors)
        ))



(defn fetch-store-settings [site-id]
  (ajax/get-json (store-source site-id)
                 {}
                 (fn [response]
                   (map-store-settings response))))

(defn init-store-settings-channel []
  (go (while true
         (fetch-store-settings (<! store-settings-channel)))))

