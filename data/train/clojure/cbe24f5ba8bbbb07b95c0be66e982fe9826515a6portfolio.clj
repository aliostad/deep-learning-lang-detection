(ns cashmgmt.portfolio
  (:require [datomic.api :only [q db] :as d]
            [cashmgmt.account :as a]
            [cashmgmt.introspect :as i]
            [cashmgmt.util.query :as qry]
            [cashmgmt.util.unique :as uq]
            [cashmgmt.util.emap :as e]
            [cashmgmt.util.date :as date]
            [clj-time.core :as time]
            [clj-time.coerce :as coerce])
  (:use [simulant.util :as sim])
  (:import [java.util.Date]))

;; (time/date-time 20130508)
;; (date/date= 20130508 20130508)
;; (def conn (u/scratch-conn))
;; (a/install-db-funcs conn)

;; (def schema (read-string (slurp (io/resource "cashmgmt/cashmgmt-schema.edn"))))
;; (d/transact conn schema)

(defn create [conn ref accs]
  "create a portfolio"
  (let [txid (d/tempid :db.part/tx)]
    (d/transact conn [
                      {:db/id txid
                       :portfolio/reference ref
                       :portfolio/position accs}])))

;; (a/create-instrument conn "b133" :bond)
;; (def b133 (a/get-instrument (d/db conn) "b133"))
;; (a/create-acc conn "a123" 10M b133)
;; (a/create-acc conn "a456" 7M b133)

;; (def a123 (a/get-acc conn "a123"))
;; (def a456 (a/get-acc conn "a456"))
;; (:account/tag a123)
;; (:account/tag a456)

;; verify that portfolio contains the account
;; (i/portfolio-accs conn "p2" (partial map (fn [[k v]] (format "%s -> %s" k v))))
;; (def accs (i/portfolio-accs conn "p2" (let [r {}] (partial map (fn [[k v]] (assoc r k v))))))
;; (first accs)
;; (second accs)

;; (a/transfer conn a123 a456 3M "cig annuity")
;; (a/transfer conn a123 a456 1M "repay debt")

;; instrument
(comment (defn create-instrument [conn instr types]
   (let [txid (d/tempid :db.part/tx)]
     (-> @(d/transact conn [{:db/id txid
                             :instrument/reference instr}
                            [:db/add txid :instrument/type types]
                            ;; (map #(:db/add txid :instrument/type %) types)
                            ])
         (tx-ent txid)))))
;; (def b133 (create-instrument conn "b133" :fixed-income))
;; (:instrument/type b133)
;; (d/q '[:find ?t
;;        :where
;;        [?e :instrument/type ?t]
;;        [?e :instrument/reference "b133"]]
;;      (d/db conn))

;; (ffirst (d/q '[:find ?e :where [?e :instrument/reference "b133"]] (d/db conn)))



;; quote
(defn add-quote
  "add a new quote for an instrument on a date (time?)"
  [conn instr at bid offer]
  (let [txid (d/tempid :db.part/tx)]
    (-> @(d/transact conn [{:db/id txid
                        :quote/instrument (qry/e instr)
                        :quote/bid bid
                        :quote/offer offer
                        :quote/at at
                            :quote/type :quote.type/closing}])
        (tx-ent txid))))

;; (def b133map (e/emap conn '[:find ?e :where [?e :instrument/reference "b133"]]))
;; b133map
;; (:instrument/type b133map)

(defn get-instr
  "find the instrument with this reference"
  [conn ref]
  (->> (d/q '[:find ?i
          :in $ ?r
          :where [?i :instrument/reference ?r]]
            (d/db conn) ref)
       ffirst
       (d/entity (d/db conn))))

;; (get-instr conn "b133")
;; (:instrument/type (get-instr conn "b133"))
;; (:db/id (get-instr conn "b133"))

(defn day-interval
  "return an interval of 1 day around the passed in date"
  [date]
  (clj-time.core/interval (clj-time.coerce/from-date date) (clj-time.core/plus date (clj-time.core/days 1))))

;; (time/within? (day-interval (time/date-time 2013 05 20)) (time/date-time 2013 05 20))

(defn format-date [d]
  (-> (java.text.SimpleDateFormat. "yyyyMMdd") (.format d)))
;; (format-date (java.util.Date.))

;; (add-quote conn b133map (java.util.Date.) 12M 13M )
(defn quote-for
  "find a CLOSING quote for an instrument on a date"
  [dbval instr date]
  (let [iid (:db/id instr)
        interval (day-interval date)]
    (->> (d/q '[:find  (clj-time.coerce/to-long ?fqd)
            :in $ ?qi ?date ?interval
            :where
                [?q :quote/type :quote.type/closing]
                [?q :quote/at ?qd]
                [?q :quote/instrument ?qi]
                ;; [(clj-time.core/within? ?interval (clj-time.coerce/from-date ?date))]
                [(clj-time.coerce/from-date ?qd) ?fqd]
                ;; [(clj-time.core/within? ?interval ?fqd)]
                ;;[(= ?date ?qd)]
                ]
              dbval iid date interval)
         ffirst
         (d/entity dbval))))

;; (def t0 (coerce/from-date (java.util.Date.)))
;; (add-quote conn b133 t0 8M 9M)
;; (def quote (quote-for (d/db conn) (get-instr conn "b133") t0))
;; (:quote/bid quote)
;; (map (fn [k] k) quote)

;; (time/day (coerce/from-date (java.util.Date.)))

;; (uq/list-existing-values (d/db conn) :instrument/type)
;; (uq/list-existing-values-e "b133" (d/db conn) :instrument/type)

;; (uq/assert-on-emap conn b133map :instrument/type [:pp1 :pp2 :b2])

;; valuation func
(def ut
  #db/fn {:lang :clojure
          :params [dbval instr-id quote-id qty]
          :code (let [quote (d/entity dbval quote-id)
                      instr (d/entity dbval entity-id)]
                  (if-let [price (:quote/offer quote)]
                    (* price qty)
                    0M))}
  )


;; position
(defn position-for
  "create a position in an instrument. By position, we mean the value of a holding at a point in time."
  [conn acc quote valfn]
  (let [;;txid (d/tempid :db.part/tx)
        ;; val (valfn (:account/balance acc) quote)
        val 10]
    ;; (d/transact conn [{:db/id txid
    ;;                    :position/value-date ((clj-time.core/now))
    ;;                    :position/value val
    ;;                    :position/quote quote
    ;;                    :position/account acc}]))
    val
    ))

;; (let [acc (a/get-acc conn "a123")
;;       instr (:account/instrument acc)]
;;   (->> (quote-for instr (clj-time.core/date-time 20130515))
;;        :quote/at)
;;   )


(comment design
  p ->* p ->* acc
  portfolios are view across accounts, accounts belong to a legal entity and record all flows for an instrument.
  they also indicate the status of the asset (avail, reserved, intransit).
  portfolios can be nested and can track one another
  p(123) -> {:x 100, :y 300}  -> a(a234) {:x 100} a(988) {:y 300}

  acc is a collection of operational transactions (or entries) which when netted return the position in the account

  p (333) -> {:x 100 :y 50}  p (444) tracks p (333), as p (333) changes either through market movements or re-adjustment, so too does p (444)

  concerns
  where do positions fit into this model?
  are they needed?
  positions can be thought of as the aggregation of accounts by investor, product provider, desk, book.

  p ->* accs
  p ->* p
  p -> value date
  p ->


)
