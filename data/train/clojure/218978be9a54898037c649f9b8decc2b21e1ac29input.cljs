(ns word-finder.components.input
  (:require [reagent.core :as reagent]
            [re-frame.core :as rf :refer [dispatch subscribe]]
            [word-finder.schemas.word-schemas :as schemas]))

(defn- track-text-val
  "Reset val to the current value from the event `evt`."
  [val evt]
  (->> evt
       .-target
       .-value
       (reset! val)))

(defn input-text-field
  [dispatch-fn]
  (let [val (reagent/atom "")]
    (fn input-text-field-render []
      [:input {:type        "text"
               :value       @val
               :on-change   #(->> %
                                  .-target
                                  .-value
                                  (reset! val))
               :on-key-down #(case (.-which %)
                               13 (dispatch-fn @val)
                               nil)}])))

(defn regex-input-field
  "Create a component that will validate against the regex schema. If
  it passes, it will call the dispatch-fn."
  [{:keys [dispatch-fn]}]
  (let [val            (reagent/atom "")
        error-val      (reagent/atom nil)
        start-dispatch (fn []
                         (if-let [err (schemas/get-error schemas/valid-input-regex @val)]
                           (do
                             (reset! error-val err))
                           (do
                             (reset! error-val nil)
                             (dispatch-fn @val))))]
    (fn input-text-field-render [a]
      [:div {}
       [:input {:className  (when @error-val ["error-input"])
                :type        "text"
                :value       @val
                :on-change   (partial track-text-val val)
                :on-key-down #(case (.-which %)
                                13 (start-dispatch)
                                nil)}]
       (when-let [evalue @error-val]
         [:span {:className ["error"]} evalue])])))

(defn show-return-values
  []
  (fn [data]
    (let [data-snapshot @data]
      (if-not (empty? data-snapshot)
        [:ul.word-list
         (doall
          (map-indexed
           (fn [idx d]
             [:li {:key (str "word." idx) :id (str "word-" idx)} d])
           data-snapshot))]))))

;; We can combine our components together and we can manage to keep
;; state changes local, the mutable parts here don't need to leak
;; outside of this scope.
(defn combined-search-component
  "This component combines the search and result components into one"
  [server-fn]
  (let [;; we will hold the server return data in here.
        data           (reagent/atom nil)
        ;; we take in the function to call and set our local r/atom so
        ;; that the second component will update.
        dispatch-fn    (fn [value]
                         (server-fn value (fn [server-data]
                                            (reset! data (get server-data "found")))))]
    (fn combined-render-fn
      []
      [:div.combined
       [:span "Enter text:"]
       [input-text-field dispatch-fn]
       [show-return-values data]])))

(defn combined-search-with-subscription
  "This component uses the re-frame subscription to set the state."
  [server-fn]
  (let [dispatch-fn (fn [value]
                      (server-fn value (fn [server-data]
                                         (dispatch [:server/found-words (get server-data "found")]))))]
    (fn combined-render-subscribe-fn
      []
      [:div.combined
       [:span "Enter text:"]
       [input-text-field dispatch-fn]
       [show-return-values (subscribe [:found-words])]])))
