(ns expense-tracker.account.utils
  (:require [expense-tracker.globals :as g]
            [expense-tracker.utils :as u]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpers

(defn gan-helper [accounts prefix rslt]
  (if (empty? accounts)
    rslt
    (let [f (first accounts)
          new-prefix (str prefix ":" (:name f))]
      (if-let [children (:children f)]
        (gan-helper (rest accounts)
                    prefix
                    (apply conj rslt new-prefix
                           (flatten (mapv #(gan-helper [%] new-prefix [])
                                          children))))
        (gan-helper (rest accounts) prefix (conj rslt new-prefix))))))

;; used by account/manage
;; where we do want top-level accounts to be used
(defn accs->names [accounts]
  (mapv #(subs % 1) (gan-helper accounts "" [])))

;; used by transaction/add
;; where we don't want top-level accounts to be used
(defn filtered-accs->names [accounts]
  (into []
        (remove #(or (= % "asset") (= % "income")
                     (= % "liability") (= % "expense"))
                (accs->names accounts))))

;; ["expenses" "vehicle"] -> [3 :children 1 :children]
;; see globals.clj for reference
(defn accs->indices [accounts]
  (loop [accs accounts
         root @g/accounts
         rslt []]
    (if (empty? accs)
      (interleave rslt (repeat :children))
      (recur (rest accs)
             (:children (first (filter #(= (first accs) (:name %)) root)))
             (conj rslt (u/find-index root (first accs) :name))))))
