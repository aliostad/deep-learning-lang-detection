(ns state-machine-rollio.core
  (:require [automat.viz :refer (view)]
            [automat.core :as a]))

;; https://github.com/ztellman/automat
;; =====================================

;; States: :order-placed :rejected :callback :email-customer

;;  Called but no answer ==> schedule callback

;;  Called and spoke to customer ==> input result
;;     or
;;  Emailed customer
;;    customer placed order ==> save order to sf & schedule delivery
;;    customer said no ==> mark rejected
;;    customer said callback ==> schedule callback time
;;    customer said email me ==> email customer

#_(

(def f (a/compile [1 2 3]))

(a/advance f nil 1)

(def adv (partial a/advance f))

(-> nil (adv 1) (adv 2) (adv 3))

;; How to manage the message returned when it is rejected
(a/advance f nil 1 :error)

;; (advance fsm state input reject-value)

(def f (a/compile
        [1 2 3 (a/$ :complete)]
        {:reducers {:complete (fn [state input] :completed)}}))



(def adv (partial a/advance f))
(-> :incomplete (adv 1) (adv 2) :value)
(-> :incomplete (adv 1) (adv 2) (adv 3) :value)


(def f (a/compile
        [(a/* a/any) (a/$ :call)
         "customer said callback"  (a/$ :schedule-callback)
         (a/* a/any)

         "customer said email"     (a/$ :email)
         (a/* a/any)

         "customer placed order"   (a/$ :deliver-food)
         (a/* a/any)

         "customer rejected sale"  (a/$ :rejected)]
        {:reducers {:call                  (fn [state input]
                                             ;; Read customer address from sf
                                             ;; Add sf write here
                                             :call)
                    :deliver-food          (fn [state input]
                                             ;; Read customer address from sf
                                             ;; Add sf write here
                                             :deliver-food)
                    :rejected              (fn [state input]
                                             ;; Write lead dead in sf
                                             :rejected)
                    :schedule-callback     (fn [state input]
                                             ;; Return to the user the script to ask
                                             ;; the customer for a callback time
                                             ;; schedule callback time in sf
                                             :callback-scheduled)
                    :email                 (fn [state input]
                                             ;; Fire off automated email
                                             :email-sent)}}))

(def adv (partial a/advance f))

(-> :call (adv "customer placed order"))

(-> :call (adv "customer rejected sale") :value)



;; = = = = = = = = =

(def f (a/compile [:initiate-lead
                   (a/or
                    (a/* :call)
                    (a/* :send-email))
                   (a/or
                    :rejected
                    :deliver-food)]))

(def adv (partial a/advance f))

(-> nil
    (adv :initiate-lead)
    (adv :call)
    (adv :send-email)
    (adv :rejected))

(a/advance f nil :initiate-lead)





(-> :incomplete (adv 1) (adv 2) (adv 3) :value)

(def pages [:cart :checkout :cart])
(def page-pattern
  (vec
   (interpose (a/* a/any) pages)))


(def conversation-pattern
  (->> [:order-placed
        :rejected
        :callback
        :email-customer]
       (map #(vector [% (a/$ :save)]))
       (interpose (a/* a/any))
       vec))

(def f
  (a/compile

   [(a/$ :init)
    page-pattern
    (a/$ :complete)]

   {:signal :page-type
    :reducers {:init (fn [m _] (assoc m :history []))
               :save (fn [m page] (update-in m [:history] conj page))
               :complete (fn [m _] (assoc m :completed? true))}}))


)
