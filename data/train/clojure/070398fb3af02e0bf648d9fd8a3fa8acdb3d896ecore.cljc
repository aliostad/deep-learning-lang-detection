(ns event-monad.core
  #?(:clj (:require [clojure.core.async :refer [go]])
     :cljs (:require-macros [cljs.core.async.macros :refer [go]]))
  (:require [#?(:clj  clojure.core.async
                :cljs cljs.core.async) :as async :refer [<! chan close! put! to-chan]]))

(defn handle-res
  [res state]
  (if (map? res)
    (->> res
         (filter (fn [[tag _]] (not= tag :state)))
         (reduce (fn [state [tags computation]]
                   (let [env (->> [tags]
                                  flatten
                                  (reduce (fn [env tag]
                                            (merge env
                                                   (get-in state [:_meta
                                                                  :interpreters
                                                                  tag])))
                                          {}))
                         res (((or (get-in state [:_meta :transformers tags])
                                   (fn [x] x)) computation) env)]
                     (handle-res res state)))
                 (merge state (:state res))))
    state))

(defn manage-events
  [handlers interpreters transformers]
  (let [event-chan (async/chan)
        dispatch-chan (async/chan)
        dispatch-queue (atom [])
        dispatch (fn [event-name args]
                   (reset! dispatch-queue (conj @dispatch-queue
                                                [event-name args]))
                   (async/go
                     (async/<! dispatch-chan)
                     (let [[[event-name args] & rest-queue] @dispatch-queue]
                       (async/>! event-chan [event-name args])
                       (reset! dispatch-queue rest-queue)
                       (async/>! dispatch-chan true))))
        default-interpreters {:dispatch {:dispatch (fn [[name args]]
                                                     (dispatch name args))}}
        default-transformers {:dispatch (fn [d] (fn [e] ((:dispatch e) d)))}]
    (async/go (async/>! dispatch-chan true))
    (async/go-loop [state {:_meta {:handlers handlers
                                   :interpreters (merge default-interpreters
                                                        interpreters)
                                   :transformers (merge default-transformers
                                                        transformers)}}]
      (let [[event-name args] (async/<! event-chan)
            event-res ((get-in state [:_meta :handlers event-name]) state args)]
        (recur (handle-res event-res state))))
    dispatch))

(defn run-sync
  [handlers interpreters transformers events]
  (let [res (atom {:done false})
        dispatch (manage-events (merge handlers
                                       {:_end (fn [state _]
                                                (reset! res {:done true
                                                             :state state})
                                                {})})
                                interpreters
                                transformers)]
    (doseq [[event-name args] (concat events [[:_end {}]])]
      (dispatch event-name args)
      (Thread/sleep 500))
    (loop []
      (Thread/sleep 3000)
      (if (:done @res)
        (:state @res)
        (recur)))))

