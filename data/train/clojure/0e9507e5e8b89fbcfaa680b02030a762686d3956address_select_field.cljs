(ns emojillionaire.components.address-select-field
  (:require
    [cljs-react-material-ui.reagent :as ui]
    [emojillionaire.styles :as st]
    [emojillionaire.utils :as u]
    [re-frame.core :refer [subscribe dispatch]]
    [reagent.core :as r]
    ))

(defn address-select-field [addresses selected-address dispatch-vec & [props]]
  (let [no-addresses? (empty? addresses)]
    [ui/select-field
     (r/merge-props
       {:value selected-address
        :on-change #(dispatch (conj dispatch-vec %3))
        :disabled no-addresses?
        :style st/text-left
        :floating-label-text (if no-addresses? "No Accounts Connected" "Choose your account")}
       props)
     (for [address addresses]
       [ui/menu-item
        {:value address
         :key address
         :primary-text (u/truncate address 25)}])]))
