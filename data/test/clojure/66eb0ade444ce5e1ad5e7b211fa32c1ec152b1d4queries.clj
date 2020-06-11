(ns summit.bh.queries
  (:require ;[korma.db :refer :all]
            [korma.core :as k :refer [database limit where values insert order fields]]
            [clojure.string :as str]
            ;; [mount.core :as mount]

            [incanter.core :as i]
            [incanter.distributions :as d]
            [incanter.stats :as stats]
            ;; [incanter.charts :as c]

            [com.rpl.specter :as s]

            [summit.utils.core :refer :all]
            [summit.db.relationships :refer :all]
            ))

(def admins-sql "
select c.*
from roles r
join grants g on r.id=g.role_id
join permissions p on p.id=g.permission_id
join customers c on c.id=r.customer_id
where account_id is null and p.resource='all' and p.action='manage'
order by c.created_at
")

(defn admins
  ([] (admins :bh-prod))
  ([db]
   (exec-sql db admins-sql)))

(examples
 (ppn (->> (admins) (map :email)))
 )

(defn last-orders [n]
  (reverse
   (dselect contact-email (database (find-db :bh-prod)) (where {:type "Order"}) (order :id :DESC) (limit n) (k/with cart) (k/with account))))

(defn last-order []
  (first (last-orders 1)))

(examples
 (last-orders 1)
 (last-order)
 (keys (last-order))
 (:customer_id_2 (last-order))
 (order-vitals (last-order))
 )

(defn open-last-order []
  (let [orders (last-orders 1)]
    (:sap_document_number (first orders))))
;; (open-last-order)

(defn order-dollars []
  (map (comp #(/ % 100.0) :total_price)
       (dselect contact-email (database (find-db :bh-prod)) (where {:type "Order"}) (fields [:total_price]))))

(defn last-order-sans-json []
  (dissoc (last-order) :sap_json_result))

(defn orders-by [email]
  (dselect contact-email (database (find-db :bh-prod)) (where {:type "Order" :email email}) (order :id :DESC) (limit 1)))
;; (order-vitals (last-order))
;; (count (orders-by (:email (last-order))))
;; (:created_at (ddetect customer (where {:email (:email (last-order))})))

(defn order-vitals [order]
  (let [o (into {} (s/select [s/ALL #(contains? #{:id :total_price :email :name :created_at :sap_document_number :delivery_method :message} (first %))] order))
        service-center (if (:service_center_id order)
                         (find-by-id :service_centers (:service_center_id order)))
        service-center-name (if service-center (:long_name service-center))
        addr (str/join ", " [(:address order) (:city order) (:state order) (:zip order)])
        ]
    (dissoc
     (assoc (clojure.set/rename-keys o {:name :customer-name :email :customer-email})
            :total_price (/ (:total_price o) 100.0)
            :created (localtime (:created_at o))
            :account_name (:name_2 order)
            :account (str "https://www.summit.com/store/credit/accounts/" (:account_number order))
            :customer (str "https://www.summit.com/store/credit/customers/" (:customer_id_2 order))
            :service_center service-center-name
            :shipping_address addr
            ;; :order-full order
            )
     :created_at)))

(defn sorted-order-vitals [order]
  (into (sorted-map) (order-vitals order)))
;; (sorted-order-vitals (last-order))





;; these require incanter.charts, which only works with xwindows.
;; currently have this disabled because I'm using mosh

;; (defn qqplot-order-dollars []
;;   (let [os (order-dollars)]
;;     (-> (c/qq-plot os)
;;         (i/view))))
;; ;; (qqplot-order-dollars)

;; (defn boxplot-order-dollars []
;;   (let [os (order-dollars)]
;;     (-> (c/box-plot os
;;                     :series-label "Dollars per Order"
;;                     :legend true
;;                     :y-label "$")
;;         (i/view)
;;         )))
;; ;; (boxplot-order-dollars)

;; (defn plot-order-dollars []
;;   (let [os (order-dollars)]
;;     (-> (c/xy-plot (range 1000) os
;;                    :series-label "Dollars per Order"
;;                    :legend true
;;                    :x-label "Order #"
;;                    :y-label "$")
;;         (c/add-points (range 1000) os)
;;         (i/view)
;;         )))




;; (def ooo (last-order))
;; (order-vitals ooo)
;; (pp (mapv order-vitals (last-orders 5)))
;; (pp (order-vitals (last-order)))

(examples
 (last-order-sans-json)
 (pp (last-order-sans-json))
 (pp (mapv order-vitals (last-orders 5)))
 (qqplot-order-dollars)
 (boxplot-order-dollars)
 (plot-order-dollars)
 )

