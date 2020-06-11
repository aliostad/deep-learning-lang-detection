(ns simulator-app.actions.click
    (:require-macros [cljs.core.async.macros :refer [go]])
    (:require [simulator-app.actions.http :as http]
              [simulator-app.utils.router.history :refer [push-history!]]))

(defn click-update [{:keys [path method] :as app}]
    (let [url (if method (str "/update/" method path) path)]
        (fn [{dispatch :dispatch}]
            (push-history! url app)
            (dispatch {:type :view-update
                       :path url
                       :app  app}))))

(defn click-reset! [app]
    (fn [{dispatch :dispatch}]
        (go (<! (dispatch (http/reset-sim! app)))
            (dispatch (http/get-apps)))))

