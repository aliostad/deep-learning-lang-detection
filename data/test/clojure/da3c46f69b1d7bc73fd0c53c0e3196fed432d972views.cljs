(ns odin.orders.admin.views
  (:require [antizer.reagent :as ant]
            [iface.typography :as typography]
            [odin.orders.admin.create :as create]
            [odin.utils.formatters :as format]
            [re-frame.core :refer [dispatch subscribe]]
            [reagent.core :as r]))

;;; How might we use an orders view?
;; - Orders begin life as "pending" (i.e. "new") -- these require attention.
;;   - Orders that are pending that have a price already set can be processed
;; - "Placed" orders can be considered "in-progress" and non-cancelable
;;   - Orders that are placed can be charged.

;;; We'll want to be able to filter orders by status, sort by creation date


;; =============================================================================
;; Table
;; =============================================================================


(defn- wrap-cljs [f]
  (fn [x record]
    (f x (js->clj record :keywordize-keys true))))


(defn- render-service [_ {:keys [service]}]
  (:code service))


(defn- render-total [_ {:keys [price quantity]}]
  (format/currency (* price (or quantity 1))))


(defn- render-price [_ {price :price}]
  (if (some? price) (format/currency price) "N/A"))


(defn- render-status [_ {status :status}]
  (case status
    :order.status/pending "new"
    :order.status/placed  "in-progress"
    status))


(def ^:private columns
  [{:title     "Name"
    :dataIndex :name}
   {:title     "Service"
    :dataIndex :service
    :render    (wrap-cljs render-service)}
   {:title     "Member"
    :dataIndex :account
    :render    #(.-name %)}
   {:title     "Created"
    :dataIndex :created
    :render    format/date-time-short}
   {:title     "Billed On"
    :dataIndex :billed_on
    :render    #(if (some? %) (format/date-time-short %) "N/A")}
   {:title     "Price"
    :dataIndex :price
    :render    (wrap-cljs render-price)}
   {:title     "#"
    :dataIndex :quantity
    :render    (fnil format/number 1)}
   {:title     "Total"
    :dataIndex :total
    :render    (wrap-cljs render-total)}
   {:title     "Status"
    :dataIndex :status
    :render    (wrap-cljs render-status)}
   {:title     "Billed"
    :dataIndex :billed
    :render    (wrap-cljs #(get-in %2 [:service :billed]))}])


(defn- expanded [record]
  (or (.-desc record) "N/A"))


(defn orders-table []
  (let [orders     (subscribe [:admin/orders])
        is-loading (subscribe [:loading? :admin.orders/fetch])]
    [ant/table
     {:loading           @is-loading
      :columns           columns
      :expandedRowRender (comp expanded r/as-element)
      :dataSource        (map-indexed #(assoc %2 :key %1) @orders)}]))


;; =============================================================================
;; Controls
;; =============================================================================

(defn checkable-tags []
  (let [tags (r/atom [{:name "all" :key :all}
                      {:name "new" :key :pending}
                      {:name "in progress" :key :placed}
                      {:name "canceled" :key :canceled}
                      {:name "charged" :key :charged}])]
    [:div
     (doall
      (for [{:keys [name key]} @tags]
        ^{:key key}
        [ant/tag-checkable-tag
         {:on-change #(dispatch [:admin.orders.status/select key])
          :style     {:font-size   18
                      :line-height "26px"
                      :height      "30px"}}
         [:span name]]))]))



;; =============================================================================
;; Entrypoint
;; =============================================================================


;; TODO: Wire up checkable-tags w/ actual data, drives query params
;; TODO: Add download as csv button
;; TODO: Create order modal
;; TODO: Create order mutation
;; DONE: Add services query w/ fulltext search term `q`
;; DONE: Extend accounts query w/ fulltext search term `q`
;; TODO: Place order mutation/action for orders
;; TODO: Process order mutation/action for orders


(defn view []
  [:div
   (typography/view-header "Orders" "Manage and view premium service orders.")
   ;; [:hr]
   ;; [:div.chart-controls
   ;;  ]

   ;;; controls
   [:div.columns {:style {:margin-top 24 :margin-bottom 24}}
    [:div.column
     [checkable-tags]]
    [:div.column
     [:div.is-pulled-right [create/button]]]]
   [:div
    [orders-table]]])
