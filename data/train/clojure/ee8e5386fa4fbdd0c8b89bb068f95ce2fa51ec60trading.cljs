(ns btc-market.trading
  (:require [btc-market.common :as c :refer [refresh-control]]
            [re-frame.core :refer [dispatch subscribe]]
            [reagent.core :as r]
            [btc-market.db :as db]
            [clojure.string :as str]
            [clojure.spec.alpha :as s]))

(defn buy-sell-view [[order]]
  (let [new-trade (r/atom order)
        field-style (-> c/col-style (dissoc :width :padding))
        picker-style (dissoc field-style :font-size)]

    (fn [[order]]
      [c/scroll-view {:style (assoc c/screen-style :margin-horizontal 10) :height "100%"
                      :content-container-style {:align-items "center"}}
       [c/text {:style c/title-style}
        (str (str/upper-case (db/order-sides (:orderSide @new-trade))) " "
             (db/instruments (:instrument @new-trade)))]
       [c/view {:style (merge c/row-style
                              c/form-style {:height "100%"})}
        [c/text {:style field-style} "Order Type"]
        [c/picker {:style picker-style :selected-value (:ordertype @new-trade)
                   :on-value-change #(swap! new-trade assoc :ordertype %1)}
         [c/picker-item {:label "Select" }]
         [c/picker-item {:label "Limit" :value "Limit"}]
         [c/picker-item {:label "Market" :value "Market"}]]
        [c/text {:style field-style} "Volume"]
        [c/text-input {:style field-style :keyboard-type "numeric"
                       :on-change-text #(swap! new-trade assoc :volume %)} (:volume @new-trade)]
        [c/text {:style field-style} "Price"]
        [c/text-input {:style field-style :keyboard-type "numeric"
                       :editable (= "Limit" (:ordertype @new-trade))
                       :on-change-text #(swap! new-trade assoc :price %)}
         (:price @new-trade)]
        [c/text {:style (assoc field-style :color "#333")}
         (str "Total: " (* (:price @new-trade) (:volume @new-trade)))]
        [c/text ""]
        [c/touchable-highlight
         {:style c/button-style :on-press #(dispatch [:exec-order @new-trade])}
         [c/text {:style c/button-text} (db/order-sides (:orderSide @new-trade))]]]])))

(defn open-orders-view [instrument]
  (r/with-let [trades (subscribe [:open-orders instrument])
               col-style {:font-size 16  :color (c/colors :primary-text) :padding 5}
               col-view-style {:width "100%"}]
    (if (seq @trades)
      [c/view {:style c/screen-style}
       [c/text {:style (assoc c/title-style :font-size 22)} "Open Orders"]
       (for [{:keys [id instrument orderSide ordertype price status openVolume]} @trades]
         ^{:key id}
         [c/view {:style c/row-style}
          [c/text {:style (assoc c/text-style :width "90%" :font-size 20)}
           (str (db/order-sides orderSide) " " openVolume " " instrument " @ $" price " = $" (* price openVolume))]
          [c/touchable-highlight
           {:style (assoc c/button-style :flex 1  :border-radius 40 :margin 2)
            :on-press #(dispatch [:cancel-order id])}
           [c/text {:style c/button-text} "-"]]])])))
