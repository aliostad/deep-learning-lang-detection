(ns eckersdorf.routes.core
  (:require [re-frame.core :as rf]
            [bidi.bidi :as bidi]
            [pushy.core :as pushy]
            [taoensso.timbre :as timbre]))


(def routes
  ["/"
   [["" :main-page]
    [["category/" [#".+" :slug]] :category]
    [["product/" [#".+" :slug]] :product]
    [["search/" [#".+" :text]] :search]
    [["" [#".*" :panel]] :panel]]])

(defn dispatch-route [match]
  (let [handler (:handler match)]
    (case handler
      :main-page (do
                   (rf/dispatch [:warehouse/deselect-category])
                   (rf/dispatch [:warehouse/deselect-product])
                   (rf/dispatch [:warehouse/reset-search-field])
                   (rf/dispatch [:warehouse/request-products])
                   (rf/dispatch [:warehouse/reset-breadcrumbs]))
      ;:panel (rf/dispatch [:routes/set-active-panel (:route-params match)])
      :category (rf/dispatch [:routes/category (:route-params match)])
      :product (rf/dispatch [:routes/product (:route-params match)])
      :search (rf/dispatch [:routes/search (:route-params match)])
      nil)))


(defn match-route [path]
  (or (bidi/match-route routes path)
      (timbre/warn "handler for path: " path " not exists!")))

(def history (pushy/pushy dispatch-route match-route))


(defn init []
  (pushy/start! history))


(defn set-token! [token]
  (pushy/set-token! history token))


(defn get-token! []
  (pushy/get-token history))


(defn path-for [tag & args]
  (apply bidi/path-for routes tag args))




