(ns rivulet.init
  (:require [immutant.messaging :as msg]
            [rivulet.control :as control]
            [rivulet.producer :as producer]
            [rivulet.daemon :as daemon]
            [rivulet.web :as web]))

(def destinations {:stream-dest "topic.stream"
                   :command-dest "topic.commands"
                   :result-dest "topic.matches"})

(defn init []
  (mapv msg/start (vals destinations))
  (control/init destinations)
  (daemon/init destinations
                :incoming [:command-dest]
                :outgoing [:stream-dest])
  (producer/init (:stream-dest destinations))
  (web/init))
