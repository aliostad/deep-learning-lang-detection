(ns herald.handlers.ws
  (:require [herald.services.veye :as veye]
            [herald.db :as db]
            [herald.utils.core :as utils]
            [herald.models.api :as api-mdl]
            [herald.models.stars.user-api-token :as UAT-star]
            [herald.use-cases [manage-api :as uc-api]
                              [manage-repos :as uc-repos]
                              [import-repos :as uc-source]
                              [manage-veye-project :as uc-veye]]
            [herald.schemas :as schemas
                            :refer [->HError]]
            [clojure.core.match :refer [match]]
            [clojure.core.async :as async
                                :refer [<! >! close! go-loop chan]]
            [chord.http-kit :refer [with-channel]]
            [environ.core :refer [env]]
            [blancas.morph.core :as morph :refer [monad]]
            [blancas.morph.monads :refer [either right]]
            [taoensso.timbre :as log])
  (:import [herald.schemas HError]))

(defmacro with-db
  [& body]
  `(db/with-connection ~(env :herald-env)
      ~@body))

(defn route-message
  [user-id message]
  (match [message]
    [{:id :ping}]
    {:id :ping :response "Pong!" :request message}

    ;;-- repo handlers
    [{:id :repos/get-all}]
    (with-db
      (either [res (uc-repos/get-user-repos user-id)]
        (->HError "Failed to fetch a list repositories" res)
        res))
    [{:id :repos/get-files}]
    (with-db
      (either [res (uc-repos/get-user-repofiles user-id)]
        (->HError "Failed to fetch list of repo-files." res)
        res))

    [{:id :repos/get-file :data dt}]
    (with-db
      (log/debug "Reading repo file for: " dt)
      (either [res (uc-repos/get-user-repofile user-id (:repofile-id dt))]
        (->HError "Failed to fetch project file." res)
        res))

    [{:id :repos/get-projects}]
    (with-db
      (either [res (uc-veye/get-user-projects user-id)]
        (->HError "Failed to fetch a list of imported projects" res)
        res))

    [{:id :repos/link-project-file :data dt}]
    (with-db
      (let [auth-request (monad [veye-auth (UAT-star/get-user-token-by-api-type
                                                user-id "veye")
                                 source-auth (UAT-star/get-user-token-by-id
                                                  user-id (:uat-id dt))]
                            (right [veye-auth source-auth]))]
        (either [api-tokens auth-request]
          (->HError ":repos/link-project-file - Failed to get API tokens" api-tokens)
          (let [file-id (get dt :id 0)
                [veye-auth source-auth] api-tokens]
            (log/debug "#-- Going to link project-file:\n" dt)
            (either [rvr-dt (with-db (uc-veye/link-by-file-id file-id veye-auth source-auth))]
              (->HError "Failed to import project file" rvr-dt)
              (either [res-dt (uc-repos/get-user-repofile user-id (:repofile-id rvr-dt))]
                (->HError "Failed to get project data from DB" res-dt)
                res-dt))))))

      [{:id :repos/unlink-project-file :data file-dt}]
      (with-db
        (let [project-id (get file-dt :veyeproject-id 0)
              file-id (:id file-dt)
              unlink-project (monad [res  (uc-veye/delete-project project-id)
                                    file (uc-repos/get-user-repofile user-id file-id)]
                              (right file))]
          (log/debug "#-- Going to unlink project file\n")
          (either [updated-file unlink-project]
            (->HError "Failed to unlink project file." updated-file)
            updated-file)))

      ;;-- sources
      [{:id :sources/get-all}]
      (with-db
        (either [res (uc-api/get-user-sources user-id)]
          (->HError "Failed to fetch a list of sources." res)
          res))

      [{:id :sources/get-repo-sources}]
      (with-db
        (either [res (uc-api/get-user-repo-sources user-id)]
          (->HError "Failed to fetch a list of API owners." res)
          res))

      [{:id :sources/update-data :data dt}]
      (with-db
        (log/debug "#-- update-data: \n" dt)

        (either [source-auth (UAT-star/get-user-token-by-id user-id (:uat-id dt))]
          (->HError "No tokens for API" source-auth)
          (let [import-task (monad [_ (uc-repos/delete-user-repos-by-uat user-id
                                                                         (:uat-id dt))
                                    file-ch (uc-source/import-project-files user-id
                                                                            (:uat-id dt)) ]
                              (right file-ch))]
            (either [file-ch import-task]
              (->HError "Failed to import a repositories data." file-ch)
              (let [response-ch (chan)]
                (go-loop []
                  (when-let [file-dt (<! file-ch)]
                    (either [dt (with-db (uc-repos/get-user-repos user-id))]
                      (>! response-ch
                          (->HError "Failed to fetch repo stream" dt))
                      (>! response-ch dt))
                    (recur)))
                response-ch)))))

      [{:id :sources/add-new :data msg-data}]
      (with-db
        (either [res (uc-api/add-user-source user-id msg-data)]
          (->HError "Failed to save a new API endpoint." res)
          res))

      [{:id :sources/update-one :data msg-data}]
      (with-db
        (either [res (uc-api/update-user-source user-id msg-data)]
          (->HError "Failed to update an API endpoint." res)
          res))

      [{:id :sources/delete-one :data msg-data}]
      (with-db
        (either [res (uc-api/delete-user-source user-id msg-data)]
          (->HError "Failed to delete an API endpoint." res)
          res))

;;-- TOKENS

      [{:id :tokens/get-all}]
      (with-db
        (either [res (uc-api/get-user-tokens user-id)]
          (->HError "Failed to fetch user's tokens" res)
          res))

      [{:id :tokens/add-new :data msg-data}]
      (with-db
        (either [res (uc-api/add-user-token user-id msg-data)]
          (->HError "Failed to save a new API token." res)
          res))

      [{:id :tokens/update-one :data msg-data}]
      (let [token-id (:token-id msg-data)]
        (with-db
          (either [res (uc-api/update-user-token user-id token-id msg-data)]
            (->HError "Failed to update the API token" res)
            res)))

      [{:id :tokens/delete-one :data msg-data}]
      (let [{:keys [token-id api-id]} msg-data]
        (with-db
          (either [res (uc-api/delete-user-token user-id api-id token-id)]
            (->HError "Failed to delete a user token" res)
            res)))

      :else
        (->HError "Unknown message id" message)))

(defmulti send-response
  (fn [_ _ resp]
    (cond
      (schemas/herror? resp)  :error
      (schemas/chan? resp)    :stream
      :else                   :default)))

(defmethod send-response :error [msg-id ws-channel response]
  (log/error "ws-request error - " msg-id ": " response)
  (async/put! ws-channel
              {:id msg-id
               :error {:msg (:msg response)
                       :data (pr-str (:data response))}}))

(defmethod send-response :stream [msg-id ws-channel response-ch]
  (log/info "ws-stream: " msg-id)
  (go-loop []
    (when-let [response (<! response-ch)]
      (log/info "sending stream item for: " msg-id)
      (>! ws-channel {:id msg-id
                      :data response})
      (recur))))

(defmethod send-response :default [msg-id ws-channel response]
  (log/info "default ws-response: " msg-id)
  (async/put! ws-channel
              {:id msg-id
               :data response}))

(defn ws-api-handler
  [{:keys [ws-channel] :as req}]
  (log/debug "Opened connection from: " (:remote-addr req))
  ;(put! ws-channel {:id :ping :data "Hello from server!"})

  (if-let [user-id (get-in req [:session :uid])]
    (go-loop []
      (when-let [{:keys [message error]} (<! ws-channel)]
        (if error
          (log/error "ws-api-handler: " error)
          (when-let [result (route-message user-id message)]
            (send-response (:id message)
                           ws-channel
                           result)
            (recur)))))

    (do
      (log/error "Not authorized request.")
      {:status 401
       :body "unauthorized websocket request!"})))


