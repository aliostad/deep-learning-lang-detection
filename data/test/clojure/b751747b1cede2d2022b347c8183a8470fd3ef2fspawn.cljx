(ns utils.spawn
  (:require
   [instrument.decorators
    :refer [decorate]]
   #+clj [clojure.core.async
          :refer [>! put! take! chan go go-loop alts!]]
   #+cljs [cljs.core.async
                    :refer [>! put! take! chan alts!]])
  #+cljs (:require-macros [cljs.core.async.macros
                           :refer [go]]))

(defn go-fn
  [f]
  (fn [& args]
    (let [ch (chan)]
      (go
       (let [result (apply (decorate f) args)]
         (println "args:" args "result:" result)
         (>! ch result)))
      ch)))

