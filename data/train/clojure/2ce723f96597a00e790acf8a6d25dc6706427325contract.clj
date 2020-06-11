(ns trading.contract)

(defn- make
  ([counterparty instrument amount price position]
   "Construct a contract with an implied primary party"
   (make :this-organization counterparty
         instrument amount price position))
  ([primary-party counterparty instrument amount price position]
   "Construct a contract with an explicit primary party"
   {:primary-party primary-party
    :counterparty counterparty
    :instrument instrument
    :amount amount
    :price price
    :position position}))

(defn make-long
  "Construct a long contract"
  ([counterparty instrument amount price]
   (make counterparty instrument amount price :long))
  ([primary-party counterparty instrument amount price]
   (make primary-party counterparty instrument amount price :long)))

(defn make-short
  "Construct a short contract"
  ([counterparty instrument amount price]
   (make counterparty instrument amount price :short) )
  ([primary-party counterparty instrument amount price]
   (make primary-party counterparty instrument amount price :short)))

(defn primary-party [contract]
  (:primary-party contract))

(defn counterparty [contract]
      (:counterparty contract))


