(ns centipair.store.product
  (:use korma.core
        centipair.core.db.connection))


(defentity product)


(defn insert-product [params]
  (insert product
          (values {:product_sku (:product-sku params)
                   :product_title (:product-title params)
                   :product_short_description (:product-short-description params)
                   :product_long_description (:product-long-description params)
                   :product_active (:product-active params)
                   :product_condition (:product-condition params)
                   :product_featured (:product-featured params)
                   :product_manage_stock (:product-manage-stock params)
                   :product_stock (:product-stock params)
                   })))




(defn update-product [params]
  
  )

(defn new-product [params]
  
  )

(defn save-product [params]
  
  )



