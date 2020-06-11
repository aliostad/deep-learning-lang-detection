(ns childrensfutures-trade.address-select-field
  (:require
    [cljs-react-material-ui.reagent :as ui]
    [childrensfutures-trade.utils :as u]
    [re-frame.core :refer [dispatch]]
    [reagent.core :as r]))

;;;
;;; dispatch vec is [[] []]
;;;
(defn address-select-field [addresses selected-address dispatch-vec & [props]]
  (let [no-addresses? (empty? addresses)]
    [ui/select-field
     (r/merge-props
       {:value selected-address
        :on-change #(let [v %3]
                      (apply  dispatch (vec (map (fn [x] (conj x v)) dispatch-vec))))
        :disabled no-addresses?
        :style {:text-align :left}
        :floating-label-text (if no-addresses? "No Accounts Connected" "Choose your account")}
       props)
     (for [address addresses]
       [ui/menu-item
        {:value address
         :key address
         :primary-text (u/truncate address 25)}])]))
