(ns edgar.core.tee.live

  (:require [edgar.ib.market :as market]
            [edgar.core.edgar :as edgar]
            [edgar.core.analysis.lagging :as alagging]
            [edgar.core.signal.common :as common]
            [edgar.core.signal.lagging :as slagging]
            [edgar.core.signal.leading :as sleading]
            [edgar.core.signal.confirming :as sconfirming]
            [edgar.core.strategy.strategy :as strategy]
            [edgar.core.strategy.target :as target]
            ))


(def ^:dynamic *tracking-data* (ref []))
(def ^:dynamic *orderid-index* (ref 100))

(defn track-strategies
  "Follows new strategy recommendations coming in"
  [tick-list strategy-list]

  ;; iterate through list of strategies
  (reduce (fn [rA eA]

            #_(println (str "... 1 > eA[" eA "] > some test if/else[" (some #(= % (:tickerId eA)) (map :tickerId @*tracking-data*)) "]"))
            ;; does tickerId of current entry = any tickerIds in existing list?
            (if (some #(= % (:tickerId eA))
                      (map :tickerId @*tracking-data*))


              ;; for tracking symbols, each new tick -> calculate:
              ;;     $ gain/loss
              ;;     % gain/loss
              (dosync (alter *tracking-data* (fn [inp]

                                               (let [result-filter (filter #(= (-> % second :tickerId) (:tickerId eA))
                                                                           (map-indexed (fn [idx itm] [idx itm]) inp))]

                                                 #_(println (str "... 2 > value[" (ffirst (seq result-filter))
                                                               "] / result-filter[" (seq result-filter)
                                                               "] / input[" (type inp) "][" inp "]"))

                                                 ;; update-in-place, the existing *tracking-data*
                                                 ;; i. find index of relevent entry
                                                 (into [] (update-in inp
                                                                     [(ffirst (seq result-filter))]
                                                                     (fn [i1]

                                                                       #_(println (str "... 3 > update-in inp[" i1 "]"))
                                                                       (let [price-diff (- (:last-trade-price (first tick-list)) (:orig-trade-price i1))
                                                                             merge-result (merge i1 {:last-trade-price (:last-trade-price (first tick-list))
                                                                                                     :last-trade-time (:last-trade-time eA)
                                                                                                     :change-pct (/ price-diff (:orig-trade-price i1))
                                                                                                     :change-prc price-diff})]

                                                                         #_(println (str "... 4 > result[" merge-result "]"))
                                                                         merge-result))))))))

              ;; otherwise store them in a hacked-session
              (dosync (alter *tracking-data* conj {:uuid (:uuid eA)
                                                 :symbol (:symbol tick-list)
                                                 :tickerId (:tickerId eA)
                                                 :orig-trade-price (:last-trade-price eA)
                                                 :orig-trade-time (:last-trade-time eA)
                                                 :strategies (:strategies eA)
                                                 :source-entry eA}))))
          []
          strategy-list))

(defn watch-strategies
  "Tracks and instruments existing strategies in play"
  [tick-list]

  #_(println (str "... 1 > WATCH > watch-strategies > test[" (some #(= % (:tickerId (first tick-list)))
                                                 (map :tickerId @*tracking-data*)) "]"))

  ;; check if latest tick matches a stock being watched
  (if (some #(= % (:tickerId (first tick-list)))
            (map :tickerId @*tracking-data*))

    (dosync (alter *tracking-data* (fn [inp]

                                   (let [result-filter (filter #(= (-> % second :tickerId) (:tickerId (first tick-list)))
                                                               (map-indexed (fn [idx itm] [idx itm]) inp))]

                                     #_(println (str "... 2 > WATCH > result-filter[" (into [] result-filter) "] / integer key[" (first (map first result-filter)) "] / inp[" (into [] inp) "]"))

                                     ;; update-in-place, the existing *tracking-data*
                                     ;; i. find index of relevent entry
                                     (into [] (update-in (into [] inp)
                                                          [(first (map first (into [] result-filter)))]
                                                          (fn [i1]

                                                            #_(println (str "... 3 > WATCH > update-in > inp[" i1 "]"))
                                                            (let [

                                                                  ;; find peaks-valleys
                                                                  peaks-valleys (common/find-peaks-valleys nil tick-list)
                                                                  peaks (:peak (group-by :signal peaks-valleys))

                                                                  stoploss-threshold? (target/stoploss-threshhold? (:orig-trade-price i1) (:last-trade-price (first tick-list)))
                                                                  reached-target? (target/target-threshhold? (:orig-trade-price i1) (:last-trade-price (first tick-list)))


                                                                  ;; ensure we're not below stop-loss
                                                                  ;; are we: at 'target'

                                                                  ;; OR

                                                                  ;; are we: abouve last 2 peaks - hold
                                                                  ;; are we: below first peak, but abouve second peak - hold
                                                                  ;; are we: below previous 2 peaks - sell

                                                                  action (if stoploss-threshold?

                                                                           {:action :down :why :stoploss-threshold}

                                                                           (if (every? #(>= (:last-trade-price (first tick-list))
                                                                                            (:last-trade-price %))
                                                                                       (take 2 peaks))

                                                                             {:action :up :why :abouve-last-2-peaks}

                                                                             (if (and (>= (:last-trade-price (first tick-list))
                                                                                          (:last-trade-price (nth tick-list 2)))
                                                                                      (<= (:last-trade-price (first tick-list))
                                                                                          (:last-trade-price (second tick-list))))

                                                                               {:action :up :why :abouve-second-below-first-peak}

                                                                               {:action :down :why :below-first-2-peaks})))


                                                                  price-diff (- (:last-trade-price (first tick-list)) (:orig-trade-price i1))
                                                                  merge-result (merge i1 {:last-trade-price (:last-trade-price (first tick-list))
                                                                                          :last-trade-time (:last-trade-time (first tick-list))
                                                                                          :change-pct (/ price-diff (:orig-trade-price i1))
                                                                                          :change-prc price-diff
                                                                                          :action action})]

                                                              #_(println (str "... 4 > WATCH > result[" merge-result "]"))
                                                              merge-result))))))))))

(defn trim-strategies [tick-list]

  (println (str "... trim-strategies / SELL test[" (some #(= :down (-> % :action :action)) @*tracking-data*)
                "] / ACTION[" (seq (filter #(= :down (-> % :action :action)) @*tracking-data*))
                "] / WHY[" (seq (filter #(= :down (-> % :action)) @*tracking-data*)) "]"))
  (dosync (alter *tracking-data*
                 (fn [inp]
                   (into [] (remove #(= :down (-> % :action :action))
                                    inp))))))


(defn manage-orders [strategy-list result-map tick-list-N]

  ;; track any STRATEGIES
  (let [strategy-list-trimmed (remove nil? (map first strategy-list))]

    (if (-> strategy-list-trimmed empty? not)

      (track-strategies tick-list-N strategy-list-trimmed)))


  ;; watch any STRATEGIES in play
  (if (not (empty? @*tracking-data*))
    (watch-strategies tick-list-N))


  ;; ORDER based on tracking data
  (let [client (:interactive-brokers-client edgar/*interactive-brokers-workbench*)
        tick (first @*tracking-data*)]

    (if (some #(= :up (-> % :action :action))
              (filter #(= (:tickerId %) (-> tick-list-N first :tickerId)) @*tracking-data*))

      ;; only buy that which we are not already :long
      (if-not (= :long
                 (-> (filter #(= (:tickerId %) (-> tick-list-N first :tickerId)) @*tracking-data*)
                     first
                     :position))
        (do

          ;; ... TODO: make sure we don't double-buy yet
          ;; ... TODO: track orderId for sale
          ;; ... TODO: stock-symbol has to be tied to the tickerId
          (println "==> BUY now")
          (dosync (alter *tracking-data* (fn [inp]

                                           (let [result-filter (filter #(= (-> % second :tickerId) (:tickerId (first tick-list-N)))
                                                                       (map-indexed (fn [idx itm] [idx itm]) inp))]

                                             ;; i. find index of relevent entry
                                             (update-in (into [] inp)
                                                        [(first (map first (into [] result-filter)))]
                                                        (fn [i1]

                                                          #_(println (str "... 3 > BUY > update-in > inp[" i1 "]"))
                                                          (let [merge-result (merge i1 {:order-id *orderid-index*
                                                                                        :position :long
                                                                                        :position-amount 100
                                                                                        :position-price (:last-trade-price (first tick-list-N))})]

                                                            #_(println (str "... 4 > BUY > result[" merge-result "]"))
                                                            (market/buy-stock client @*orderid-index* (:symbol result-map) 100 (:last-trade-price tick))

                                                            merge-result)))))))
          (dosync (alter *orderid-index* inc))))

      (if (some #(= :down (-> % :action :action))
                (filter #(= (:tickerId %) (-> tick-list-N first :tickerId)) @*tracking-data*))

        (if (= :long
                 (-> (filter #(= (:tickerId %) (-> tick-list-N first :tickerId)) @*tracking-data*)
                     first
                     :position))
          (do

            (println "==> SELL now / test[" (filter #(= (:tickerId %) (-> tick-list-N first :tickerId)) @*tracking-data*) "] ")
            (dosync (alter *tracking-data* (fn [inp]

                                             (let [result-filter (filter #(= (-> % second :tickerId) (:tickerId (first tick-list-N)))
                                                                         (map-indexed (fn [idx itm] [idx itm]) inp))]

                                               ;; i. find index of relevent entry
                                               (update-in (into [] inp)
                                                          [(first (map first (into [] result-filter)))]
                                                          (fn [i1]

                                                            (println (str "... 3 > SELL > update-in > inp[" i1 "]"))
                                                            (let [merge-result (merge i1 {:position :short
                                                                                          :position-amount 100
                                                                                          :position-price (:last-trade-price (first tick-list-N))})]

                                                              (println (str "... 4 > SELL > result[" merge-result "]"))
                                                              (market/sell-stock client @(:order-id i1) (:symbol result-map) 100 (:last-trade-price tick))
                                                              merge-result)))))))

            ;; remove tracked stock if sell
            (if (not (empty? @*tracking-data*))
              (trim-strategies tick-list-N))))))))


(defn tee-fn [output-fn stock-name result-map]

  #_(println (str "get-streaming-stock-data result-map[" result-map "]"))
  (let [tick-list-N (map (fn [inp]
                           (assoc inp
                             :total-volume (read-string (:total-volume inp))
                             :last-trade-size (read-string (:last-trade-size inp))
                             :vwap (read-string (:vwap inp))
                             :last-trade-price (read-string (:last-trade-price inp))))
                         (reverse (:event-list result-map)))

        final-list (reduce (fn [rslt ech]
                             (conj rslt [(:last-trade-time ech) (:last-trade-price ech)]))
                           []
                           tick-list-N)


        sma-list (alagging/simple-moving-average nil 20 tick-list-N)
        smaF (reduce (fn [rslt ech]
                       (conj rslt [(:last-trade-time ech) (:last-trade-price-average ech)]))
                     []
                     sma-list)

        ema-list (alagging/exponential-moving-average nil 20 tick-list-N sma-list)
        emaF (reduce (fn [rslt ech]
                       (conj rslt [(:last-trade-time ech) (:last-trade-price-exponential ech)]))
                     []
                     ema-list)

        signals-ma (slagging/moving-averages 20 tick-list-N sma-list ema-list)
        signals-bollinger (slagging/bollinger-band 20 tick-list-N sma-list)
        signals-macd (sleading/macd nil 20 tick-list-N sma-list)
        signals-stochastic (sleading/stochastic-oscillator 14 3 3 tick-list-N)
        signals-obv (sconfirming/on-balance-volume 10 tick-list-N)

        sA (strategy/strategy-A tick-list-N
                                signals-ma
                                signals-bollinger
                                signals-macd
                                signals-stochastic
                                signals-obv)

        #_sB #_(strategy/strategy-B tick-list-N
                                signals-ma
                                signals-bollinger
                                signals-macd
                                signals-stochastic
                                signals-obv)

        sC (strategy/strategy-C tick-list-N
                                signals-ma
                                signals-bollinger
                                signals-macd
                                signals-stochastic
                                signals-obv)

        result-data {:stock-name stock-name
                     :stock-symbol (:symbol result-map)
                     :stock-list final-list
                     :source-list tick-list-N
                     :sma-list smaF
                     :ema-list emaF
                     :signals {:moving-average signals-ma
                               :bollinger-band signals-bollinger
                               :macd signals-macd
                               :stochastic-oscillator signals-stochastic
                               :obv signals-obv}
                     :strategies {:strategy-A sA
                                  #_:strategy-B #_sB
                                  :strategy-C sC}}]

    (println "")
    (println (str "... latest-tick[" (first tick-list-N) "] > *tracking-data*[" (seq @*tracking-data*) "]"))
    (println (str "... strategy-A[" sA "] / strategy-B[" #_sB "] / strategy-C[" sC "] / test[" (or (not (empty? sA))
                                                                                                 #_(not (empty? sB))
                                                                                                 (not (empty? sC)))"]"))

    (manage-orders [sA sC] result-map tick-list-N)

    (output-fn "stream-live" result-data)))
