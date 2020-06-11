(ns shared.models.event.index
  (:require [cljs.spec :as spec]
            [shared.models.event.to-models :refer [to-models]]
            [shared.protocols.convertible :as cv :refer [Convertible]]
            [shared.protocols.specced :refer [Specced]]
            [shared.specs.core :as specs]))

(spec/fdef create
           :args (spec/cat :event-type ::specs/event)
           :ret ::specs/event
           :fn #(spec/valid? ::specs/meta (-> %1 :ret :meta)))

(defn override [event]
  (specify event
    Convertible
    (-to-models [this] (to-models this))
    Specced
    (-resolve [[data-type :as this]]
      (let [payload-type (-> (spec/conform (:spec (meta this)) this) second first)]
        [data-type payload-type]))))

(defn create [[source type payload]]
  (-> [(keyword type) payload]
      (with-meta {:spec ::specs/event
                  :source source
                  :timestamp (.now js/Date)})
      override))

#_(stest/instrument `create)
