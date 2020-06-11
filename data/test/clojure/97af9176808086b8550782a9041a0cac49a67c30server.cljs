(ns homesale.server
  (:require [cljsjs.firebase]
            [re-frame.core :refer [dispatch]]))

(def fb-url "https://haneyhome.firebaseio.com")
(def base-ref (js/Firebase. fb-url))

;;
;; Helpers
;;
(defn child* [fbref & [path & paths]]
  (if-not path
    fbref
    (recur (.child fbref path) paths)))

(defn child [& paths]
  (apply child* base-ref paths))

;;
;; monitor firebase authentication
;;
(.onAuth base-ref
  (fn [auth-data]
    (if auth-data
      (dispatch [:fb-auth (js->clj (.-auth auth-data) :keywordize-keys true)])
      (dispatch [:fb-unauth]))))

;;
;; Firebase authentication
;;
(defn login! [email password]
  (.authWithPassword base-ref #js {:email email :password password}
                     (fn [error auth-data]
                       (dispatch [:fb-login-result error auth-data]))
                     #js {:remember "sessionOnly"}))

(defn logout! []
  (.unauth base-ref))

;;
;; Firebase handlers
;;
(doto (child "users")
  (.on "child_added" #(dispatch [:fb-child-added :users %1]))
  (.on "child_changed" #(dispatch [:fb-child-changed :users %1]))
  (.on "child_removed" #(dispatch [:fb-child-removed :users %1])))

(doto (child "sale-level")
  (.on "child_added" #(dispatch [:fb-child-added :sale-levels %1]))
  (.on "child_changed" #(dispatch [:fb-child-changed :sale-levels %1]))
  (.on "child_removed" #(dispatch [:fb-child-removed :sale-levels %1])))

(doto (child "item-area")
  (.on "child_added" #(dispatch [:fb-child-added :item-areas %1]))
  (.on "child_changed" #(dispatch [:fb-child-changed :item-areas %1]))
  (.on "child_removed" #(dispatch [:fb-child-removed :item-areas %1])))

(doto (child "items")
  (.on "child_added" #(dispatch [:fb-child-added :items %1]))
  (.on "child_changed" #(dispatch [:fb-child-changed :items %1]))
  (.on "child_removed" #(dispatch [:fb-child-removed :items %1])))


