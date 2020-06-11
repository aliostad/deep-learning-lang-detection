(ns lipstick.reframe.effects
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [re-frame.core :as rf :refer [reg-fx dispatch console]]
            [cljs.core.async :refer [<!]]
            [re-frame.core :as rf]
            [cljs-http.client :as http]
            [taoensso.timbre :as log]))


(rf/reg-fx :load-file
  (fn load-file [{:keys [url on-success on-failure] :as req}]
    (if req
      (go (let [{:keys [status body]} (<! (http/get url))]
            (if (< status 300)
              (rf/dispatch (conj on-success body))
              (rf/dispatch (conj on-failure body))))))))