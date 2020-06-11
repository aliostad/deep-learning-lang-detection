(ns tagalong-middle.core
  (:gen-class)
  (:require [com.ashafa.clutch :as c]
            [clojure.core.async :as a]))

(def dispatch-db (assoc (cemerick.url/url "https://dwoodlock.cloudant.com/tagalong_dispatch")
          :username "ftedictiontiverstrustrin"
          :password "20c9f6fee4da63003649f0b1d6b6ee2fbb6fe342"))

(def main-db (assoc (cemerick.url/url "https://dwoodlock.cloudant.com/tagalong")
                   :username "auldimenneedissasenowdre"
                   :password "2fd53c981c25972e66235ff2259850e0b39eb246"))

(def log-db (assoc (cemerick.url/url "https://dwoodlock.cloudant.com/tagalong_logs")
               :username "appousureatteninjuntstio"
               :password "7c5976d4ca72c7b15d4be82b19c15441db7e84cd"))

(defn log [& args]
  (do (apply println args)
      (c/put-document
        log-db
        {:datetime (java.util.Date.) :arguments args})))

(defn get-all-dispatches []
  (c/all-documents dispatch-db {:include_docs true}))

(defn delete-dispatch [doc]
  (c/delete-document dispatch-db doc))

(defn process-doc [doc]
  (log "processing id " (:_id doc))
  (if (= (:type doc) "INCREMENT")
    (let [master-doc (c/get-document main-db "reducer")
          updated-doc (update-in master-doc [:state :count] inc)]
      (do (c/put-document main-db updated-doc)
          (log "Success with id " (:_id doc))
          (delete-dispatch doc))
      )))

(defn process-existing-queue []
  (do (log "processing existing queue...")
      (let [all-dispatches (get-all-dispatches)]
        (dorun (map (fn [d] (process-doc (:doc d))) all-dispatches)))))

(defn print-dispatch [change]
  (let [dispatch-doc (:doc change)]
    (if (and dispatch-doc (not (:_deleted dispatch-doc)))
      (process-doc dispatch-doc))))

(def change-agent
  (c/change-agent dispatch-db :include_docs true))

(defn listen-for-new-dispatches []
  (log "listening for new dispatches...")
  (c/start-changes change-agent)
  (add-watch
    change-agent
    :process
    (fn [key agent previous-change change]
      (print-dispatch change))))

(defn -main
  []
  (do
    (process-existing-queue)
    (listen-for-new-dispatches)))


