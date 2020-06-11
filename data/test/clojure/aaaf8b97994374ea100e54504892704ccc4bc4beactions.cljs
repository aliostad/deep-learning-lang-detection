(ns autotc-web.home.actions
  (:require [autotc-web.util.poller :as poller]
            [ajax.core :as ajax]
            [rex.ext.cursor :as cur]
            [rex.core :as r]))

(defn hide-message-action-creator [cursor]
  (fn [dispatch get-store]
    (dispatch {:type :hide-message
               :cursor cursor})))

(defn show-message-action-creator [message cursor]
  (fn [dispatch get-state]
    (let [state (cur/get-state cursor (get-state))]
      (when-let [message-timer (:message-timer state)]
        (js/clearTimeout message-timer))
      (dispatch {:type :show-message
                 :cursor cursor
                 :message message

                 :message-timer
                 (js/setTimeout
                  (fn [] (dispatch (hide-message-action-creator cursor)))
                  5000)}))))

(defn reset-timer-action-creator [cursor]
  (fn [dispatch get-store]
    (when-let [timer (:poll-agent-timer (cur/get-state cursor (get-store)))]
      (poller/stop timer))
    nil))

(defn other-server-selected? [state load-agents-for-server]
  (if (nil? load-agents-for-server)
    true
    (let [selected-server (:selected-server state)]
      (and (not (nil? selected-server))
           (not (= (:id selected-server)
                   (:id load-agents-for-server)))))))

(defn load-agents-action-creator  [server cursor]
  (fn [dispatch get-state]
    (if (other-server-selected? (cur/get-state cursor
                                               (get-state))
                                server)
      nil
      (let [url (str "/agents/list/" (:id server))]
        (ajax/GET
            url
            {:response-format (ajax/json-response-format {:keywords? true})
             :handler (fn [response]
                        (if (other-server-selected? (cur/get-state cursor
                                                                   (get-state))
                                                    server)
                          nil
                          (if (not (nil? (:agents response)))
                            (dispatch {:type :on-agents-list-loaded
                                       :cursor cursor
                                       :agents (:agents response)
                                       :branches (:branches response)
                                       :project (:project response)}))))
             :error-handler (fn [response]
                              (println response)
                              (dispatch {:type :agent-list-is-loading
                                         :cursor cursor}))})))))

(defn get-current-problems-action-creator [server cursor]
  (fn [dispatch get-state]
    (let [s (cur/get-state cursor (get-state))
          page (get-in s [:current-problems :current-page] 1)]
      (if (other-server-selected? s server)
        nil
        (ajax/GET
            "/current-problems"
            {:params {"serverId" (:id server)
                      "page" page
                      "showStackTraces" true
                      ;;(get-in s [:current-problems :show-stacktraces]false)
                      }
             :response-format (ajax/json-response-format {:keywords? true})
             :handler (fn [response]
                        (if (other-server-selected? (cur/get-state cursor
                                                                   (get-state))
                                                    server)
                          nil
                          (dispatch {:type :on-current-problems-list-loaded
                                     :cursor
                                     cursor

                                     :current-problems
                                     (get response :current-problems)

                                     :problems-count
                                     (get response :problems-count)

                                     :current-page
                                     (get response :page 1)

                                     :page-count
                                     (get response :page-count 0)
                                     ;; remove this shit, and add reducer logic
                                     ;; to preserve values

                                     :show-stacktraces
                                     (get-in s
                                             [:current-problems
                                              :show-stacktraces]
                                             false)})))
             :error-handler (fn [response]
                              (println response))})))))

(defn select-server-action-creator [selected? cursor]
  (fn [dispatch get-state]
    (let [state (cur/get-state cursor (get-state))
          current (:selected-server state)]
      (if (and (not (nil? current))
               (selected? current))
        nil
        (let [selected-server (or (->> (:servers state)
                                       (filter selected?)
                                       (first))
                                  (first (:servers state)))
              p (poller/create-poller
                 (fn []
                   (dispatch
                    (load-agents-action-creator selected-server cursor))
                   (dispatch
                    (get-current-problems-action-creator selected-server cursor)))

                 3000
                 60000)]
          (aset js/window "location" (str "#" (:alias selected-server)))
          (dispatch {:type :init-load-agent-list
                     :cursor cursor
                     :selected selected-server})
          (dispatch (reset-timer-action-creator cursor))
          (dispatch (load-agents-action-creator selected-server cursor))
          (dispatch (get-current-problems-action-creator selected-server cursor))
          (poller/start p)
          ;; TODO: do not add not serializable data into model
          ;; (add timer descriptor, not timer itself)
          (dispatch {:type :attach-poll-agent-timer
                     :cursor cursor
                     :poll-agent-timer p}))))))

(defn get-server-list-action-creator [cursor]
  (fn [dispatch get-state]
    (ajax/GET
        "/servers/list"
        {:params {}
         :response-format (ajax/json-response-format {:keywords? true})
         :handler
         (fn [response]
           (let [servers (:servers response)
                 has-any-server? (and (not (nil? servers))
                                      (> (count servers)))]
             (do
               (dispatch {:type :on-server-list-loaded
                          :cursor cursor
                          :servers servers})
               (if has-any-server?
                 (dispatch (select-server-action-creator (fn [s]
                                                           (let [anchor (->> js/window
                                                                             (.-location)
                                                                             (.-hash))]
                                                             (and (not (nil? anchor))
                                                                  (= (.substring anchor 1)
                                                                     (:alias s)))))
                                                         cursor))))))})))

(defn exec-action-for-agents-action-creator [cursor
                                             url
                                             trigger-message
                                             completed-message]
  (fn [dispatch get-store]
    (let [s (cur/get-state cursor (get-store))
          current-server-id (-> s :selected-server :id)
          agent-ids (clj->js (map identity (:selected-agents s)))]
      (do
        (dispatch (show-message-action-creator trigger-message cursor))
        (ajax/POST url
            {:params {"serverId" current-server-id
                      "agentIds" agent-ids}
             :format (ajax/json-request-format)
             :handler (fn [response]
                        (dispatch (show-message-action-creator completed-message
                                                               cursor)))
             :error-handler (fn [response] (println response))})))))


(defn reset-timer [cursor]
  (r/dispatch (reset-timer-action-creator cursor)))

(defn init-page [cursor]
  (r/dispatch {:type :init-page
               :cursor cursor}))

(defn load-server-list [cursor]
  (r/dispatch (get-server-list-action-creator cursor)))

(defn on-server-selected [server cursor]
  (r/dispatch (select-server-action-creator (fn [s] (= (:id server) (:id s))) cursor)))

(defn on-agent-selected [agent selected? cursor]
  (r/dispatch {:type :agent-selected
               :cursor cursor
               :agent agent
               :selected? selected?}))

(defn on-all-agents-selected [selected? cursor]
  (r/dispatch {:type :select-all-agents
               :cursor cursor}))

(defn filter-changed-action [cursor value]
  {:type :filter-changed
   :cursor cursor
   :value value})

(defn exec-action-for-agents [cursor url trigger-message completed-message]
  (r/dispatch (exec-action-for-agents-action-creator cursor
                                                     url
                                                     trigger-message
                                                     completed-message)))

(defn start-build [cursor]
  (exec-action-for-agents cursor
                          "/agents/startBuild"
                          "request to trigger build was sent"
                          "build triggered"))

(defn stop-build [cursor]
  (exec-action-for-agents cursor
                          "/agents/stopBuild"
                          "request to stop build was sent"
                          "build stopped"))

(defn restart-build [cursor]
  (exec-action-for-agents cursor
                          "/agents/restartBuild"
                          "request to restart build was sent"
                          "build restarted"))

(defn reboot-agent [cursor]
  (exec-action-for-agents cursor
                          "/agents/rebootAgent"
                          "request to reboot agent was sent"
                          "reboot triggered"))

(defn show-message-dialog [cursor message]
  (r/dispatch (show-message-action-creator message cursor)))

(defn hide-message-dialog [cursor]
  (r/dispatch (hide-message-action-creator cursor)))

(defn change-show-selected-only [cursor]
  (r/dispatch {:type :invert-show-selected-only
               :cursor cursor}))

(defn filter-show-all [cursor]
  (r/dispatch (filter-changed-action cursor :all)))

(defn filter-show-selected [cursor]
  (r/dispatch (filter-changed-action cursor :selected)))

(defn filter-show-not-selected [cursor]
  (r/dispatch (filter-changed-action cursor :not-selected)))

(defn select-current-problems-page [server page cursor]
  (r/dispatch
   (fn [dispatch get-state]
     (dispatch {:type :on-select-current-problems-page
                :cursor cursor
                :page page})
     (dispatch (get-current-problems-action-creator server cursor)))))

(defn toggle-stack-traces [server cursor show-stack-traces]
  (r/dispatch
   (fn [dispatch get-state]
     (dispatch {:type :on-toggle-stack-traces
                :cursor cursor
                :value show-stack-traces})
     (dispatch (get-current-problems-action-creator server cursor)))))

(defn expand-stack-trace [test-name cursor]
  (r/dispatch {:type :expand-stack-trace
               :cursor cursor
               :test-name test-name}))

(defn toggle-copy-hint [test-name show cursor]
  (r/dispatch {:type :toggle-copy-hint
               :cursor cursor
               :test-name test-name
               :show show}))

(defn mark-test-name-as-copied [test-name copied cursor]
  (r/dispatch {:type :mark-test-name-as-copied
               :cursor cursor
               :test-name test-name
               :show copied}))

(defn toggle-copy-stack-hint [test-name show cursor]
  (r/dispatch {:type :toggle-copy-stack-hint
               :cursor cursor
               :test-name test-name
               :show show}))
