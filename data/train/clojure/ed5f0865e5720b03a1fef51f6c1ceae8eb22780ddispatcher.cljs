(ns tiem.frontend.dispatcher
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [cljs.core.async :as async :refer [chan put! pub sub unsub <!]]))

(let [dispatch-chan (chan)
      dispatch-pub (pub dispatch-chan
                        (fn [[tag & args]]
                          tag))]

  (defn register [tag]
    (let [sub-chan (chan)]
      (sub dispatch-pub tag sub-chan)
      sub-chan))

  (defn unregister [tag sub-chan]
    (unsub dispatch-pub tag sub-chan))

  (defn dispatch! [tag & args]
    (put! dispatch-chan [tag args])))

(defn handle-actions [tag handler]
  (let [action-chan (register tag)]
    (go (loop [action (<! action-chan)]
          (if-let [[tag args] action]
            (do
              (apply handler args)
              (recur (<! action-chan))))))
    action-chan))
