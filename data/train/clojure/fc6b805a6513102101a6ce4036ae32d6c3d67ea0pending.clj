(ns reactor.handlers.stripe.charge.pending
  (:require [blueprints.models.payment :as payment]
            [reactor.dispatch :as dispatch]
            [reactor.handlers.common :refer :all]
            [reactor.handlers.stripe.common :as common]
            [ribbon.event :as re]))


(defmethod dispatch/stripe :stripe.event.charge/pending [deps event _]
  (let [se        (common/fetch-event (->stripe deps) event)
        charge-id (re/subject-id se)]
    (when-let [payment (payment/by-charge-id (->db deps) charge-id)]
      (payment/add-source payment (get-in (re/subject se) [:source :id])))))
