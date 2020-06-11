(ns re-frame-worker-fx.core
  (:require [cljs.core.async :refer [<!]]
            [re-frame.core :refer [reg-fx dispatch]]
            [cljs-workers.core :refer [do-with-pool!]])
  (:require-macros [cljs.core.async.macros :refer [go]]))

(reg-fx
 :worker
 (fn worker-fx
   [{:keys [pool on-success on-error] :as data}]
   (go
     (let [result-chan
           (do-with-pool! pool data)

           {:keys [state] :as result}
           (<! result-chan)]

       (if (= :success (keyword state))
         (dispatch (conj on-success result))
         (dispatch (conj on-error result)))))))
