(ns cashmgmt.account
  (:use [datomic.api :only [q db] :as d]
        [clojure.pprint]
         [simulant.util :as sim])
  (:require [clojure.java.io :as io]
            [cashmgmt.util.query :as qry])
  (:import [java.lang Exception]))

;; (def conn (util/scratch-conn))
;; (def schema (read-string (slurp (io/resource "cashmgmt/cashmgmt-schema.edn"))))
;; (d/transact conn schema)

;; instrument
(defn create-instrument [conn instr types]
  (let [txid (d/tempid :db.part/tx)]
    (-> @(d/transact conn [{:db/id txid
                        :instrument/reference instr}
                       [:db/add txid :instrument/type types]
                       ;; (map #(:db/add txid :instrument/type %) types)
                       ])
        (tx-ent txid))))

(defn get-instrument [dbval ref]
  (qry/find-by dbval :instrument/reference ref))
;; (def b133 (create-instrument conn "b133" [:bond :fixed-income]))
;; (def b133 (get-instrument (d/db conn) "b133"))

;; create account
(defn create-acc [conn ref bal instr]
  (let [txid (d/tempid :db.part/tx)]
    (-> @(d/transact conn [
                           { :db/id txid
                            :account/reference ref
                            :account/tag :account.tag/avail
                            :account/instrument (qry/e instr)
                            :account/balance bal
                            :account/min-balance -2M
                            :account/max-balance 15M}
                           ])
        (tx-ent txid))))

;; (def a123 (create-acc conn "a123" 3M (qry/e b133)))
;; (def a456 (create-acc conn "a456" 7M (qry/e b133)))

(defn get-acc [conn ref]
  (->> (q '[:find ?e :where [?e :account/reference "a123"]] (db conn))
       ffirst
       (d/entity (d/db conn))))

;; (:account/tag (get-acc conn "a123"))
;; (def a123 (get-acc conn "a123"))
;; (:db/id (d/db conn) a456) ;; same result from :db/id and d/entid

(defn balances [dbval acc-ref]
  (d/q '[:find ?b ?mnb ?mxb :in $ ?r :where
        [?e :account/reference ?r]
        [?e :account/balance ?b]
        [?e :account/min-balance ?mnb]
        [?e :account/max-balance ?mxb]] dbval acc-ref))
;; (balances "a123")

(defn balance
  [db acc-id initial-balance]
  (let [adds (d/q '[:find ?adds ?tx
                    :in $ ?account
                    :where
                    [?tx :ot/cr ?account]
                    [?tx :ot/amount ?adds]]
                  db acc-id)
        subtracts (d/q '[:find ?subtracts ?tx
                         :in $ ?account
                         :where
                         [?tx :ot/dr ?account]
                         [?tx :ot/amount ?subtracts]]
                       db acc-id)]
    (+ initial-balance
       (apply + (map first adds))
       (- (apply + (map first subtracts))))))
;; (balance (d/db conn) (:db/id a123) 0M)

(def balance-checker
  #db/fn {:lang :clojure
          :params [dbval id amount]
          :code (let [eid (datomic.samples.query/e id)
                      e (d/entity dbval eid)
                      min-bal (:account/min-balance e 0)
                      max-bal (:account/max-balance e 0)
                      forecast-bal (+ (:account/balance e 0) amount)]
                  (println "forecast-bal: " forecast-bal "min-bal: " min-bal)
                  (cond
                   (< forecast-bal min-bal)
                   {:account-balance [(format "balance: %.2f must be greater than min-balance: %.2f" forecast-bal min-bal)]}
                   (> forecast-bal max-bal)
                   {:account-balance [(format "balance: %.2f must be less than max-balance: %.2f" forecast-bal max-bal)]})
                  )}
  )


;; balance is within bounds, should return nil
;; (balances "a123")
;; (d/entity (db conn) (:db/id a123))
;; (balance-checker (db conn) a123 5M)
;; (balance-checker (db conn) a123 15M)
;; (balance-checker (db conn) a123 -500M)
;; (balance-checker (db conn) a123 -2M)

;; add balance-checker to the db
;; (d/transact conn [{:db/id (d/tempid :db.part/user)
;;                    :db/ident :account/balance-checker
;;                    :db/fn balance-checker}])

;; validate that the amt will keep balance within bounds. adjust the
;; balance for the account
(def credit
  #db/fn {:lang :clojure
                             :params [dbval id amount]
          :code (let [eid  (datomic.samples.query/e id)
                      e (d/entity dbval eid)
                      forecast-bal (+ (:account/balance eid 0) amount)]
                  (if-let [errors (d/invoke dbval :account/balance-checker dbval e amount)]
                    (throw ex-info "validation failed with errors" errors)
                    [[:db/add eid :account/balance forecast-bal]])
                  )})

;; (-> (credit (db conn) a123 21M) util/should-throw)
;; (credit (db conn) a123 3M)
;; (credit (db conn) (:db/id a123) 3M)

;; install the credit fn into the db
;; (d/transact conn [{:db/id (d/tempid :db.part/user)
;;                    :db/ident :account/credit
;;                    :db/fn credit}])


;; function to install all db functions into db
(defn install-db-funcs [db]
  (d/transact db [{:db/id (d/tempid :db.part/user)
                   :db/ident :account/credit
                   :db/fn credit}])
  (d/transact db [{:db/id (d/tempid :db.part/user)
                   :db/ident :account/balance-checker
                     :db/fn balance-checker}])
  )

;; transfer implemented as an ordinary function
(defn transfer [db from to amount note]
  (let [txid (d/tempid :db.part/tx)
        fromid (cashmgmt.util.query/e from)
        toid (cashmgmt.util.query/e to)]
    (d/transact db [[:account/credit from (- amount)]
                      [:account/credit to amount]
                      [:db/add fromid :account/transactions txid]
                      [:db/add toid :account/transactions txid]
                      {:db/id txid :ot/note note :ot/dr fromid :ot/cr toid
                       :ot/txtype :ot.txtype/capital :ot/amount amount}])))

;; (transfer conn a456 a123 1M "pay debt")
;; (transfer conn (:db/id a456) (:db/id a123) 1M "pay debt")
;; (balances "a123")
;; (balances "a456")

;; find all ot's for an account
(defn txns [dbval acc-ref]
  (map (fn [[txid txinstant]]
         (let
             [tx (d/entity dbval  txid)
              {amt :ot/amount note :ot/note when :ot/tx dr :ot/dr cr :ot/cr} tx]
           [dr cr amt note txinstant])
         ) (q '[:find ?txns ?when
        :in $ ?ar
        :where
                [?a :account/reference ?ar]
                [?a :account/transactions ?txns ?tx]
                [?tx :db/txInstant ?when]]
              dbval
      acc-ref)))


(comment (def tx-instants (reverse (sort (d/q '[:find ?when :where [_ :db/txInstant ?when]]
                                      (d/db conn))))))


;; (pprint (sort #(compare (last %1) (last %2))
;;          (seq (q '[:find ?e ?b ?t ?tx
;;                     :in $
;;                     :where
;;                     [?tx :db/txInstant ?t]
;;                     [?e :account/balance ?b ?tx]]
;;                   (-> (db conn)
;;                       ;;                    (d/since #inst "2013-03-16T11:34:15.925-00:00")
;;                       (d/since #inst "2013-03-16")
;;                       )))))

(defn balance-deltas-since [dbval t]
  (let [db (-> dbval (d/since t))]
    (seq (q '[:find ?e ?b ?t
              :where
             [?tx :db/txInstant ?t]
             [?e :account/balance ?b ?tx]]
           db))))

;; (pprint (balance-deltas-since 13194139534320))

;; using the datomic indexes directly
;; (distinct (map :e (d/datoms (d/since (db conn) #inst "2013-03-16T11:34:15.925-00:00") :eavt)))

;; now use clojure threading macros
(comment (def changed (->> (-> (db conn)
                       (d/since #inst "2013-03-16T11:34:15.925-00:00")
                       (d/datoms :eavt))
                   (map :e)
                   distinct)))

;; (pprint (map #(seq (d/entity (db conn) %)) changed))
