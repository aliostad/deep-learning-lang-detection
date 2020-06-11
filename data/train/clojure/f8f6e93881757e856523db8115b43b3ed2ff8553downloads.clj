(ns witan.gateway.components.downloads
  (:require [com.stuartsierra.component :as component]
            [taoensso.timbre            :as log]
            [clojure.core.async :as async :refer [chan go go-loop put! <! <!! close!]]
            [witan.gateway.protocols    :as p :refer [ManageDownloads]]
            [witan.gateway.queries.utils :refer [directory-url
                                                 user-header]]
            [clj-http.client :as http]))

(defrecord DownloadManager [timeout directory]
  ManageDownloads
  (get-download-redirect [component user file-id]
    (let [url (directory-url :datastore directory "file" file-id "link")
          r (http/get url {:headers (user-header user)
                           :follow-redirects false
                           :redirect-strategy :none
                           :throw-exceptions false})]
      (get-in r [:headers "Location"])))

  component/Lifecycle
  (start [{:keys [comms] :as component}]
    (log/info "Starting Download Manager")
    component)

  (stop [{:keys [comms] :as component}]
    (log/info "Stopping Download Manager")
    component))

(defn new-download-manager
  [config directory]
  (->DownloadManager (:timeout config) directory))
