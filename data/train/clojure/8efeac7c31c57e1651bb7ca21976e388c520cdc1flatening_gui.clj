(ns algorithms-clj.flatening-gui
  (:require
    [clojure.string :as str]
    ))


(def trade-1
  {:trade/id              123
   :trade/counterpart     {:counterpart/id    1
                           :counterpart/label "HSBC"}
   :trade/portfolio       {:portfolio/id    2
                           :portfolio/label "PTF"}
   :trade.instrument/spot {:payoff/nominal       1000
                           :payoff/currency-pair ["EUR" "USD"]}
   :trade/regulatory      {:regulatory/jurisdiction "EMIR"
                           :regulatory/status       {:matched  true
                                                     :reported false}}
   })

; TODO - Should work for other kind of data as well! Compare with notifiers...

(defn extract-paths
  [trade-data]
  ; TODO - You can make it tail recursive...
  (reduce
    (fn [flattened [key value]]
      (prn flattened)
      (if (map? value)
        (into flattened
          (map (fn [sub-path] (update sub-path :path conj key)))
          (extract-paths value))
        (conj flattened {:path (list key) :value value})))
    []
    trade-data))

(defn trade->trade-view
  [trade-data]
  (map
    (fn [npd-record]
      (-> npd-record
        (assoc :name (str/join "/" (map name (:path npd-record))))
        (update :path vec)))
    (extract-paths trade-data)))
