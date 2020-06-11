(ns btc-market.prices
  (:require [btc-market.common
             :as
             c
             :refer
             [refresh-control screen-style scroll-view text title-style view]]
            [btc-market.db :as db]
            [btc-market.trading :refer [buy-sell-view open-orders-view]]
            [re-frame.core :refer [dispatch subscribe]]
            [reagent.core :as r]))

(defn dashboard-view []
  (let [data (subscribe [:active-instrument-data])]
    (fn []
      [view {:style (assoc screen-style :height "100%")}
       [scroll-view
        [c/picker {:selected-value (:instrument @data)
                   :style {:color (c/colors :primary-text) :align-content "center"}
                   :on-value-change #(dispatch [:set-active-instrument %1])}
         (for [[inst symb] db/instruments]
           ^{:key inst}[c/picker-item {:label symb :value inst}])]
        [view {:style c/row-style}
         [text {:style (assoc c/text-style :font-size 20 :width "30%")} (str "$" (:bid @data))]
         [text {:style (assoc c/text-style :font-size 30 :width "40%")} (str "$" (:price @data))]
         [text {:style (assoc c/text-style :font-size 20 :width "30%")} (str "$" (:ask @data))]]
        [view {:style c/row-style}
         [text {:style (assoc c/text-style :font-size 15 :width "30%")} "Best Bid"]
         [text {:style (assoc c/text-style :font-size 15 :width "40%")} "Last Price"]
         [text {:style (assoc c/text-style :font-size 15 :width "30%")} "Best Ask"]]

        [open-orders-view (:instrument @data)]]

       [view {:style (assoc c/row-style :height 120 :background-color "transparent")}
        [c/touchable-highlight
         {:style {:width "48%" :background-color (c/colors :dark-primary) :margin-left "1.5%"}
          :on-press #(dispatch [:push-view #'buy-sell-view {:instrument (:instrument @data)
                                                            :orderSide "Bid" :price (:ask @data)}])}
         [text {:style c/button-text} "Buy"]]
        [c/touchable-highlight
         {:style {:width "48%" :background-color (c/colors :dark-primary) :margin-left "1%"}
          :on-press #(dispatch [:push-view #'buy-sell-view {:instrument (:instrument @data)
                                                            :orderSide "Ask" :price (:bid @data)}])}
         [text {:style c/button-text} "Sell"]]]])))

;; (defn tickers-view []
;;   [view {:style c/row-style}
;;    [c/text {:style c/small-text} "BTC " ]])

(defn coin-prices-view []
  (let [prices (subscribe [:coin-prices])]
    (fn []
      [view {:style {:height " 100%"}}
       [scroll-view {:style screen-style
                     :content-container-style {:align-items "center" }
                     :refresh-control (r/as-element
                                       [refresh-control {:on-refresh #(dispatch [:fetch-prices])
                                                         :refreshing false}])}
        [text {:style title-style} "Ticker"]
        [view {:style {:flex-direction "row" :width "100%"
                       :background-color "#818181"}}
         [text {:style {:font-size 16 :width "34%" :color "#fff" :padding 5}} "Currency"]
         [text {:style {:font-size 16 :width "22%" :color "#fff" :padding 5}} "Price"]
         [text {:style {:font-size 16 :width "22%" :color "#fff" :padding 5}} "Bid"]
         [text {:style {:font-size 16 :width "22%" :color "#fff" :padding 5}} "Ask"]]

        (for [[cur {:keys [price bid ask]}] @prices]
          ^{:key cur}
          [view {:style c/row-style}
           [text {:style {:font-size 16 :width "34%" :color "#fff" :padding 5}
                  :on-long-press #(js/console.log "long pressed!") } cur]
           [text {:style {:font-size 16 :width "22%" :color "#fff" :padding 5}} price]
           [text {:style {:font-size 16 :width "22%" :color "#fff" :padding 5}} bid]
           [text {:style {:font-size 16 :width "22%" :color "#fff" :padding 5}} ask]])]
       [c/touchable-highlight {:on-press #(js/console.log "+ clicked!")
                               :style {:position "absolute" :width 50 :height 50
                                       :z-index 100 :background-color "#212121"
                                       :border-radius 30 :left "80%" :top "70%"}}
        [c/text {:style {:color "#fff" :font-size 38 :text-align "center" :height "100%"
                         :text-align-vertical "center" :include-font-padding false}}  "+"]]])))
