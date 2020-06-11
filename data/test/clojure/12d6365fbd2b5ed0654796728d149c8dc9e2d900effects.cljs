(ns sixsq.slipstream.webui.panel.deployment.effects
  (:require-macros
    [cljs.core.async.macros :refer [go]])
  (:require
    [cljs.core.async :refer [<!]]
    [re-frame.core :refer [reg-fx dispatch]]
    [sixsq.slipstream.client.api.runs :as runs]))

;; usage: (dispatch [:runs-search client])
;; queries the given resource
(reg-fx
  :fx.webui.deployment/search
  (fn [[client params]]
    (go
      (let [results (<! (runs/search-runs client params))]
        (dispatch [:evt.webui.deployment/set-data results])))))
