(ns oanda.core
  (:require [clj-http.client :as client]
            [clojure.string :as str]
            [clojure.instant :as instant]
            [clojure.edn :as edn]
            ;; my staff
            [clj-fudi.core :as fudi]
            [model.heikin :refer :all]
            [util [date :refer :all] [process-csv :refer [mean variance]]
             [helpers :refer :all]]
            )
  (:import java.util.Date)
  )

(defn ->mid-candles
  "[Candle] -> [Candle]"
  [candles]
  (for [candle candles]
    (select-keys
     candle
    [:time :openMid :highMid :lowMid :closeMid :volume])))


(def GRANULARITY :m1)

(defn auth
  []
  (try (read-string (slurp (System/getProperty "auth")))
       (catch Exception e
         {})))


(defn address
  []
  (if (empty? (auth))
    "http://localhost:8080/v1/"
    "https://api-fxpractice.oanda.com/v1/"))


(defn get-accountId
  []
  (try
    (str "accountId="
         (->
          (str  (address)  "accounts")
          (client/get
           {:headers (auth)
            :as :json})
          (:body)
          (:accounts)
          (first)
          (:accountId)))
    (catch Exception e
      (println "waiting for remote server... at get-accountId")
      ;;(prn e)
      (Thread/sleep 1000)
      (get-accountId)
      ))
  )

(defn format-instr-str
  [instr]
  (str/upper-case (str/replace (name instr) "-" "_")))

(defn format-str-key
  [instr]
  (keyword (str/lower-case (str/replace instr "_" "-"))))


(defn get-instrument-list
  []
  (try
    (apply
     hash-map
     (let [instruments (->
                        (str/join [(address) "instruments?" (get-accountId)])
                        (client/get {:headers (auth) :as :json})
                        (:body)
                        (:instruments))]
       (mapcat (fn [instrument]
                 [(format-str-key (:instrument instrument))
                  (str/replace (:displayName instrument) " " "_")])
               instruments)))
    (catch Exception e
      (println "waiting for remote server... at get-instrument-list")
      (Thread/sleep 1000)
      (get-instrument-list))))

(def instruments get-instrument-list)

(defn retrieve-history
  "keyword keyword long & args -> [{}]"
  [instr granularity count & {:keys [start-time
                                     end-time
                                     include-first
                                     midpoint]
                              :or {start-time nil
                                   end-time nil
                                   include-first true
                                   midpoint true}}]
  (try
    (:candles
     (:body
      (client/get
       (str
        (address) "candles?"
        "instrument=" (format-instr-str instr)
        (when midpoint "&candleFormat=midpoint")
        "&granularity="  (str/upper-case (name granularity))

        (when start-time (str "&start=" start-time))
        (when end-time (str "&end=" end-time))
        (when-not include-first "&includeFirst=false")
        (when (nil? end-time) (str  "&count=" count)))

       {:headers (auth) :as :json})))
    (catch Exception e
      (Thread/sleep 1000)
      (println "at retrieve-history")
      (.printStackTrace e)
      (retrieve-history instr granularity count
                        :start-time start-time
                        :end-time end-time
                        :include-first include-first
                        :midpoint midpoint))))



(defn add-candle!
  [history candle]
  (conj (subvec history 1) candle))


;; (defn retrieve-history-candles
;;   [instr granularity count]
;;   (for [oanda-candle (retrieve-history instr granularity count)]
;;     oanda-candle))


(defn get-current-prices
  [& instr-pairs]
  ;; (assert (not
  ;;          (empty? instr-pairs)))

  (try
    (let [instrs
          (map format-instr-str (or instr-pairs [:xpd-usd]))
          instr-strs (->> (reduce str (interpose "%2C" instrs))
                          (str "instruments="))

          query (str (address) "prices?" instr-strs)]
      (-> (client/get query {:headers (auth) :as :json})
            :body :prices))
    (catch Exception e
      (println "at get-current-price " (class e))
      (Thread/sleep 1000)
      (apply #'get-current-prices instr-pairs))))

;;(get-current-price :eur-usd)

(defn compare-dates
  [c1 c2]
  (= (instant/read-instant-date (:time c1))
     (instant/read-instant-date (:time c2))))

;;(defn only-new-candle )


(defn candle->norm-vec
  [candle stat]
  (let [prices (filter #(instance? java.lang.Double %) (vals candle))]
    (map #(-> % (- (:mean stat)) (/ (:variance stat))) prices )))


(defn candle->vec-0-1
  [candle stat]
  (let [prices (filter #(instance? java.lang.Double %) (vals candle))]
    (map #(->0-1 % (:min stat) (:max stat)) prices ))
  )


(defrecord Stat
    [min max mean variance sd])

(defn make-stat
  [xs]
  (let [ mean (/ (reduce + xs) (count xs))
        variance (-
                  (/  (reduce + (map #(Math/pow % 2) xs)) (count xs))
                  (Math/pow mean 2))]
    (->Stat (apply min xs) (apply max xs) mean variance (Math/sqrt variance))))

(defn normalize-volume
  "[candle] -> [candle]"
  [candles & {:keys [statistical] :or {statistical false}}]
  (let [volumes (vec (map :volume candles))
        stat (make-stat volumes)
        min0 (:min stat)
        max0 (:max stat)
        normalized (if statistical
                     candles ;; not implemented
                     (loop [candles0 (transient (vec (reverse candles))) ; [0,1]
                            acc (transient [])]
                       (if (zero? (count candles0))
                         (persistent! acc)
                         (let [candle (nth candles0 (dec (count candles0)))
                               with-norm-vol (update candle
                                                     :volume ->0-1
                                                     min0 max0)]
                           (recur (pop! candles0) (conj! acc with-norm-vol))))))]
    normalized))





(defn normalize-candle
  [candle stat]
  (letfn [(normalize [x]
            (-> (- x (:mean stat))
                (/ (:sd stat))))
          ]
    (let [candle0 (select-keys candle [:openMid :highMid :lowMid :closeMid])
          candle0 (reduce #(update %1 %2 normalize) candle0 (keys candle0))]
      (merge candle candle0))))

(defn normalize-0-1-candle
  [candle stat]
  (let [candle0 (select-keys candle [:openMid :highMid :lowMid :closeMid])
        candle0 (reduce #(update %1 %2 ->0-1 (:min stat) (:max stat))
                        candle0 (keys candle0))]
    (merge candle candle0)))

(defn normalize-0-1-candles
  [candles stat]
  (for [candle candles]
    (normalize-0-1-candle candle stat)))

(defn history-loop
  [ & [maskfn instr granularity]]
  (let [maskfn (or maskfn prn)
        instr (or instr :eur-usd)
        granularity (or granularity GRANULARITY)]

    (future
      (loop [old-candle nil]
        (if (not (nil? old-candle))
          (do
            (let [new-candle (first (retrieve-history instr granularity 1))
                  ;;_ (prn "new candle: " (str new-candle))
                  ]
              (if (compare-dates old-candle new-candle)
                (do
                  (Thread/sleep 1000)
                  (recur new-candle))
                (do ; else
                  ;; execute function on candle
                  (maskfn new-candle)

                  (Thread/sleep 2500)
                  (recur new-candle)))))
          (do
            (Thread/sleep 1000)
            (recur (first (retrieve-history instr granularity 1)))); else
          )))))


(defn prices-loop
  [& {:keys [instr interval maskfn]
                      :or {instr :eur-usd, interval 1000
                           maskfn prn}}]
  (future (while true
            (let [prices (-> (get-current-prices instr))]
              (maskfn prices))
            (Thread/sleep interval))))




(defn candles->stat
  [candles]
  (if (not (empty? candles))

    (let [values (->>
                  candles
                  (map #(vals (select-keys % [:openMid :highMid :lowMid :closeMid])))
                  (flatten))
          mu (mean values)
          v (variance values mu)
          sd (Math/sqrt v)

          ]
      {:mean mu
       :variance v
       :sd sd
       :max (apply max values)
       :min (apply min values)})
    nil))




(defn candles->pseudo-stat
  [candles]
  (let [max-high (reduce
                  #(if (pos? (compare %1 (:highMid %2)))
                     %1
                     (:highMid %2))
                  Double/MIN_VALUE candles)
        min-low (reduce
                 #(if (pos? (compare %1 (:lowMid %2)))
                    (:highMid %2)
                    %1)
                 Double/MAX_VALUE candles)
        mu (-> min-low (+ max-high) (/ 2))
        v  (- max-high min-low)
        ]
    {:mean mu
     :variance v
     :sd v
     :max max-high
     :min min-low}))









(defn history->pd
  [hist & {:keys [host port maskfn pause]
           :or {host :localhost port 3000
                maskfn identity pause 5}}]
  (doseq [h hist]
    (do
      (Thread/sleep pause)
      (fudi/send-udp (maskfn  h) host port))))


(def send-series history->pd)



(defn move-window
  [history & {:keys [steps instrument leftovers]
              :or {steps 1
                   instrument (->Instrument :eur-usd GRANULARITY)
                   leftovers []}}]
  (if (empty? history)
    []
    (let [last-time-rcf (-> history last :time
                            (instant/read-instant-date)
                            (rcf3339-url))
          new-candles (retrieve-history
                       (:symbol instrument)
                       (:granularity instrument)
                       steps
                       :start-time last-time-rcf
                       :include-first false)
          times (set (for [candle history] (:time candle)))
          new-candles (filter #(not (contains? times (:time %))) new-candles)
          moved (not (empty? new-candles))
          new-history (if-not moved
                        history
                        (vec (concat (drop (count new-candles) history) new-candles)))
          new-leftovers (concat leftovers (take (count new-candles) history))
          new-leftovers (vec (if (empty? leftovers)
                               new-leftovers
                               (take (count leftovers) new-leftovers)))

          ]
      [new-leftovers new-history  moved]
      )))

(defn update-window
  "outputs vector with historical candles of lenght (count history)
  where first candle is after last in input history"
  [history instrument & {:keys [midpoint] :or {midpoint true}}]
  (let [last-time (-> history last :time
                      (instant/read-instant-timestamp))
        c (count history)
        first-time (-> history first :time
                       (instant/read-instant-timestamp))
        span-ms (- (.getTime last-time) (.getTime first-time))

        end-time (new Date (+ (.getTime last-time) span-ms ))
        now (new Date)
        end-time (if (.after end-time now) now end-time)
        start-time (new Date (- (.getTime end-time) span-ms))]
    (try
      (retrieve-history (:symbol instrument)
                        (:granularity instrument)
                        c
                        :start-time (rcf3339-url start-time)
                        ;; :end-time (rcf3339-url end-time)
                        :midpoint midpoint
                        :include-first false)
      (catch Exception e
        (Thread/sleep 2000)
        (update-window history instrument :midpoint midpoint)))))




;; (defn candle->heikin [prev curr]
;;   (let [close (+ ())])
;;   )
