(ns com.gooddata.cl-splunk.saved-search
  (:gen-class)
  (:use [slingshot.slingshot :only [try+ throw+]])
  (:require [com.gooddata.cl-splunk :as splunk]
            [clj-time.core :as time]
            [clj-time.coerce :as time-coerce]
            [clj-time.format :as time-format]
            [clojure.string :as string])
  (:import (com.splunk Service SavedSearch SavedSearchCollection)))



(defn get-saved-searches
  [splunk]
  (.getSavedSearches splunk))

(defn get-by-name
  [searches name]
  (.get searches name))

(defn get-all
  [searches]
  (let [items (for [key (.keySet searches)]
                [key (.get searches key)])]
    (into {} items)))

(defn create
  [searches name query]
  (.create searches name query))


(def resources '(
                 "/gdc/account/login POST 200"
                 "/gdc/account/profile/X GET 200"
                 "/gdc/account/profile/X/projects GET 200"
                 "/gdc/account/token GET 200"
                 "/gdc/app/account/bootstrap GET 200"
                 "/gdc/app/projects/X/execute POST 201"
                 "/gdc/app/projects/X/log POST 204"
                 "/gdc/md/X/dataResult/X GET 200"
                 "/gdc/md/X/dataResult/X GET 202"
                 "/gdc/md/X/dataResult/X GET 204"
                 "/gdc/md/X/dataResult/X HEAD 200"
                 "/gdc/md/X/dataResult/X HEAD 202"
                 "/gdc/md/X/dataResult/X HEAD 204"
                 "/gdc/md/X/drillcrosspaths POST 200"
                 "/gdc/md/X/etl/pull POST 200"
                 "/gdc/md/X/etl/task/X GET 200"
                 "/gdc/md/X/ldm/manage POST 200"
                 "/gdc/md/X/maintenance/partialmdimport POST 200"
                 "/gdc/md/X/obj/X GET 200"
                 "/gdc/md/X/obj/X POST 200"
                 "/gdc/md/X/obj/X/validElements POST 200"
                 "/gdc/md/X/tasks/X/status GET 200"
                 "/gdc/md/X/tasks/X/status GET 202"
                 "/gdc/md/X/userfilters GET 200"
                 "/gdc/projects/X GET 200"
                 "/gdc/projects/X/connectors/pardot/integration/processes POST 201"
                 "/gdc/projects/X/connectors/zendesk3/integration GET 200"
                 "/gdc/projects/X/connectors/zendesk3/integration/processes POST 201"
                 "/gdc/projects/X/notifications/events POST 204"
                 "/gdc/projects/X/users/X/permissions GET 200"
                 "/gdc/releaseInfo GET 200"
                 "/gdc/xtab2/executor3 POST 201"
                 ))

(defn -main
  [& args]
  (let [spl (splunk/connect)
        searches (get-saved-searches spl)]
    (dorun
     (map-indexed (fn [idx resource]
                    (let [name (str "AAL-SLA-KRES-" (string/replace resource #"[ /]" "_"))
                          query (str "index=pms search_name=\"si_resource_slas\" resource=\""
                                     resource
                                     "\" | stats count, perc90(time) as time90, perc85(time) as time85 by _time, resource | lookup resource_slas resource output target | where not isnull(target) | eval color=if(time90<=target, \"green\", if(time85<=target, \"yellow\", \"red\")) | where color=\"red\"
")]
                      (doto (create searches name query)
                        (.setDispatchEarliestTime "-2h@h")
                        (.setDispatchLatestTime "-0h@h")
                        (.setActionEmailTo "bohumil.koutsky@gooddata.com")
                        (.setCronSchedule (str (+ idx 5) " * * * *"))
                        (.setIsScheduled true)
                        (.setAlertType "number of events")
                        (.setAlertThreshold "1")
                        (.setAlertComparator "greater than")
                        (.setAlertTrack "true")
                        (.setAlertSuppress true)
                        (.setAlertSuppressPeriod "1d")
                        (.update)))) resources))))





