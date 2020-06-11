(ns cashmgmt.core
  (:use [cashmgmt.account]
        [cashmgmt.portfolio]
        [cashmgmt.util unique date emap])
  (:require [cashmgmt.util.repl :as util]
            [clojure.java.io :as io]
            [datomic.api :only [q db] :as d]))

(def conn (util/scratch-conn))
(install-db-funcs conn)

(def dbval (d/db conn))
(def cashmgmt-schema (read-string (slurp (io/resource "cashmgmt/cashmgmt-schema.edn"))))
(d/transact conn cashmgmt-schema)

;; install the valuation function - needs to move elsewhere
(d/transact conn [{:db/id (d/tempid :db.part/user)
                    :db/ident :vfuncs/function
                    :db/fn ut}] )

(def r153 (create-instrument conn "R153" :bond))
(def a789 (create-acc conn "a789" 10M r153))
(:account/tag a789)
(def qr153 (add-quote conn r153 (java.util.Date.) 10M 11M))

(comment
  create a portfolio now which has holdings in a789 which is a position based on quote qr153.
  Now vary this quote and assert the new portfolio values.)
(comment (position-for dbval a789 qr153 (r153)))

;; seed an account with a holding in an instrument
;; then value the a portfolio which has holds the position in this account
;; the value will vary based on the price of the underlying asset.
;; If a desired ratio was stipulated for the portfolio, then a compensating order
;; should be created to bring the portfolio back into alignment

(comment
  (in {:zar :a123}
      clear-thru [:ca444])
  )

(comment - example use of mutimethods
  (defn balance-available? [amount balance] (> balance amount))

(defmulti withdraw balance-available?)

(defmethod withdraw true [amount balance]
  (- balance amount))

(defmethod withdraw false [amount balance]
  (throw (Error. "Insufficient balance available!")))
)
