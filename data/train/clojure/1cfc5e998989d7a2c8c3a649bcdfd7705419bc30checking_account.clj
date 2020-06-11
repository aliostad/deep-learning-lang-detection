(ns clojure-presentation-bws2014.example.checking-account
  (:require[compojure.core :refer :all]
              [liberator.core :refer [defresource]]
              [cheshire.core  :refer :all]
              [clojure.tools.logging :refer :all]
              [clj-logging-config.log4j :refer :all]))

(set-logger! :pattern "[%d{yyyy-MM-dd HH:mm:ss}][%p] %m%n")

;;;References are one of the clojure STM state types.
(def checking-account (ref 0.0M))

;;;Multi methods are a way to do polymorphims in clojure
;;;The method below supports a dispatch function
(defmulti transaction
  ;;Anonymous function definition with ordered parameter reference
  #(first (keys %)))

;;; The default implementation is dispatched to
;;; whenever there is no method match.
(defmethod transaction :default
  [description]
  (info "Invalid transaction."))

(defmethod transaction :deposit
  [{deposit :deposit}] ; Function argument destructuring
  ;;STM transaction
  (dosync
   (info "SUCCESS: Deposit of " deposit "$.")
   (alter checking-account + (bigdec deposit))))

(defmethod transaction :withdraw
  [description]
  (let [{:keys [withdraw delay] ;Locals destructuring with defaults
         :or {withdraw 0
              delay 0}}
        description
        report
        (ref false)]
    (info (str "NOTICE:Withdrawal for " withdraw "$ received"))
    (dosync
     (Thread/sleep (bigdec delay))
     (when (> @checking-account (bigdec withdraw))
       (alter checking-account - (bigdec withdraw))
       (ref-set report true)))
    (if @report
      (info (str "SUCCESS: Withdrawal for " withdraw "$."))
      (info (str "DECLINED: Withdrawal for " withdraw "$.")))))



;;; The main checking-account resources.
;;; Single instance - deposit/withdraw, get state.
(defresource manage-checking-account
  :available-media-types ["application/json"]
  :allowed-methods [:get :post]

  ;;Called by get requests.
  ;;Alternative syntax for anonymous functions
  :handle-ok (fn [context]
               (generate-string {:balance @checking-account}))

  ;;State updated(side effects) during a post request.
  :post! (fn [context]
           (if-let [params (get-in context [:request :json-params])]
             (transaction params)))

  ;;Response provided by a post request
  ;; _ is idiomatic for unused parameters.
  :handle-created (fn [_] (generate-string {:balance @checking-account})))

(defroutes checking-account-route
  (ANY "/checking-account" request manage-checking-account))
