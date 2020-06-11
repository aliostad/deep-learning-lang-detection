(ns simulator-app.actions.http
    (:require-macros [cljs.core.async.macros :refer [go]])
    (:require [cljs-http.client :as http]
              [cljs.core.async :refer [<!]]
              [simulator-app.actions.main :as main]
              [clojure.string :as s]))

(defn- process-http
    ([response on-success] (process-http response on-success #(-> nil)))
    ([response on-success on-failure]
     (if (< (:status response) 400)
         (on-success response)
         (on-failure response))))

(defn- receive-apps [apps]
    {:type :receive-apps
     :apps apps})

(defn get-apps []
    (fn [{dispatch :dispatch}]
        (go (let [response (<! (http/get "/simulators"))]
                (process-http response #(dispatch (receive-apps (:body %))))))))

(defn get-app [path]
    (fn [{:keys [dispatch get-state]}]
        (go (<! (dispatch (get-apps)))
            (dispatch (main/set-app! (:apps (get-state)) (s/split path #"/"))))))

(defn reset-sim! [{:keys [method path] :as app}]
    (fn [{dispatch :dispatch}]
        (go (let [response (<! (http/delete (str "/" method path)))]
                (process-http response #(dispatch {:type :simulator-reset}))))))
