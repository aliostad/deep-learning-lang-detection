(ns cjmt.core
  (:gen-class))

(set! *warn-on-reflection* true)
(set! *unchecked-math* true)

(def ^:const NUM_RECORDS (* 50 1000 444))

(definterface IMemTest
  (^long gtradeId [])
  (^long gclientId [])
  (^long gvenueId [])
  (^long ginstrumentCode [])
  (^long gprice [])
  (^long gquantity [])
  (^char gside [])
  (stradeId [^long v])
  (sclientId [^long v])
  (svenueId [^long v])
  (sinstrumentCode [^long v])
  (sprice [^long v])
  (squantity [^long v])
  (sside [^char v]))

(deftype CJMemTest [^:unsynchronized-mutable ^long tradeId
                    ^:unsynchronized-mutable ^long clientId
                    ^:unsynchronized-mutable ^long venueId
                    ^:unsynchronized-mutable ^long instrumentCode
                    ^:unsynchronized-mutable ^long price
                    ^:unsynchronized-mutable ^long quantity
                    ^:unsynchronized-mutable ^char side]
  IMemTest
  (gtradeId [_] tradeId)
  (gclientId [_] clientId)
  (gvenueId [_] venueId)
  (ginstrumentCode [_] instrumentCode)
  (gprice [_] price)
  (gquantity [_] quantity)
  (gside [_] side)
  (stradeId [this v] (set! tradeId v) nil)
  (sclientId [this v] (set! clientId v) nil)
  (svenueId [this v] (set! venueId v) nil)
  (sinstrumentCode [this v] (set! instrumentCode v) nil)
  (sprice [this v] (set! price v) nil)
  (squantity [this v] (set! quantity v) nil)
  (sside [this v] (set! side v) nil))

(def trades ^objects (make-array IMemTest NUM_RECORDS))

(defn init-trades []
  (let [trades ^objects trades]
    (loop [i 0]
      (when (< i NUM_RECORDS)
        (doto ^CJMemTest (aget trades i)
          (.stradeId i)
          (.sclientId i)
          (.svenueId 123)
          (.sinstrumentCode 321)
          (.sprice i)
          (.squantity i)
          (.sside (if (zero? (bit-and i 1)) \S \B)))
        (recur (inc i))))))

(defn perform-run [^long run-num]
  (let  [start-t (System/currentTimeMillis)
         trades ^objects trades
         tlen (alength trades)]
    (init-trades)
    (loop [idx 0
           buy-cost (bigint 0)
           sell-cost (bigint 0)]
      (if (< idx tlen)
        (let [trade-ref ^CJMemTest (aget trades idx)]
          (if (= \B (.gside trade-ref))
            (recur (inc idx) (+ buy-cost (* (.gprice trade-ref) (.gquantity trade-ref))) sell-cost)
            (recur (inc idx) buy-cost (+ sell-cost (* (.gprice trade-ref) (.gquantity trade-ref))))))
        (do
          (printf "Run %d had duration " run-num)
          (print (- (System/currentTimeMillis) start-t))
          (println "ms")
          (printf "buycost = %d sellCost = %d \n" (biginteger buy-cost) (biginteger sell-cost)))))))

(defn run []
  (dotimes [i NUM_RECORDS] (aset ^objects trades i (CJMemTest. 1 1 1 1 1 1 \a)))
  (dotimes [i 5] (System/gc) (perform-run i)))

(defn -main []
  (run))
