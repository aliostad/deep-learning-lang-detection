; Copyright © 2013 - 2016 Dr. Thomas Schank <Thomas.Schank@AlgoCon.ch>
; Licensed under the terms of the GNU Affero General Public License v3.
; See the "LICENSE.txt" file provided with this software.

(ns cider-ci.server.dispatcher.dispatch.timeout-sweeper
  (:require
    [cider-ci.server.dispatcher.trials :as trials]

    [cider-ci.utils.config :as config :refer [get-config]]
    [cider-ci.utils.daemon :as daemon :refer [defdaemon]]
    [cider-ci.utils.rdbms :as rdbms :refer [get-ds]]

    [clojure.java.jdbc :as jdbc]
    [honeysql.sql :refer :all]

    [clojure.tools.logging :as logging]
    [logbug.catcher :as catcher]
    [logbug.debug :as debug]

    ))


(defn ^:private dispatch-timeout-query []
  (when-let [trial_dispatch_timeout (:trial_dispatch_timeout (get-config))]
    (-> (sql-select :id)
        (sql-from :trials)
        (sql-merge-where [:= :state "pending"])
        (sql-merge-where (sql-raw  (str "(created_at < (now() - interval '" trial_dispatch_timeout "'))")))
        (sql-format))))


(defn ^:private sweep-in-dispatch-timeout []
  (catcher/snatch
    {}
    (jdbc/with-db-transaction [tx (rdbms/get-ds)]

      (doseq [id (->> (dispatch-timeout-query)
                      (jdbc/query tx)
                      (map :id))]
        (catcher/snatch
          {}
          (jdbc/update! tx :trials
                        {:state "aborted"}
                        ["id = ? " id])
          (jdbc/insert! tx :trial_issues
                       {:trial_id id
                        :title "Aborted due to Dispatch Timeout"
                        :description (str "This trail has been aborted because it "
                                          " could not have been dispatched within the"
                                          " configured `trial_dispatch_timeout`.")}))))))

(defdaemon "sweep-in-dispatch-timeout" 1 (sweep-in-dispatch-timeout))

(defn initialize []
  (start-sweep-in-dispatch-timeout))

;#### debug ###################################################################
;(debug/debug-ns *ns*)
;(logging-config/set-logger! :level :debug)
;(logging-config/set-logger! :level :info)

