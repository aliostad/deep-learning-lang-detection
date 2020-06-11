(ns commos.service.react
  (:require [commos.service :as service]
            [cljs.core.async :refer [chan put! take! <! >! close!]]
            [minreact.core :as m :refer-macros [defreact]])
  (:require-macros [cljs.core.async.macros :refer [go-loop go]]
                   [commos.service.react]))

(comment
  ;; Spec like this
  {k [service spec opts]}

  ;; Service invokes fn with
  {k v}

  ;; Then we want a macro a la
  (with-services {service {sym spec}}
    ;; body using sym
    ))

(comment
  ;; internal state
  {:subscriptions k->ch
   :values k->v})

(defn- calc-subs
  [old new]
  [(remove (fn [[k v]]
             (= (get new k) v))
           old)
   (remove (fn [[k v]]
             (= (get old k) v))
           new)])

(defn- dispatch-loop
  [ch component k]
  (take! ch
         (fn [v]
           (when v
             (m/state! component
                       #(cond-> %
                          ;; Check whether subscription is still active
                          (identical? (get-in % [:subscriptions k]) ch)
                          (assoc-in [:values k] v)))
             (dispatch-loop ch component k)))))

(defn- start-dispatch!
  [component spec]
  (let [k->ch (into {}
                    (map (fn [[k [service spec {:keys [xf]}]]]
                           [k (chan 1 xf)]))
                    spec)]
    (m/state! component update :subscriptions merge k->ch)
    (doseq [[k [service spec {:keys [xf]}]] spec]
      (let [ch (k->ch k)]
        (service/request service spec ch)
        (dispatch-loop ch component k)))))

(defn- stop-dispatch!
  [component spec]
  (doseq [[k [service]] spec]
    (let [ch (get-in (m/state component) [:subscriptions k])]
      (service/cancel service ch)))
  (m/state! component #(-> %
                           (update :subscriptions
                                   (partial apply dissoc) (keys spec))
                           (update :values
                                   (partial apply dissoc) (keys spec)))))

(defreact wrap-services
  [spec render-ext]
  :state {:keys [values] :as state}
  :this-as c
  (fn componentDidMount []
    (start-dispatch! c spec))
  (fn componentWillReceiveProps [[next-spec _]]
    (let [[rem-spec add-spec] (calc-subs spec next-spec)]
      (stop-dispatch! c rem-spec)
      (start-dispatch! c add-spec)))
  (fn componentWillUnmount []
    (stop-dispatch! c spec))
  (fn wrapping render []
    (render-ext values)))
