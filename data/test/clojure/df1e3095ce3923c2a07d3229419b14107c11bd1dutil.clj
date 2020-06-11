(ns breeze.util
  (:import (org.apache.storm.topology OutputFieldsDeclarer IComponent)))


(defn output-fields-sniffer
  []
  (let [viewed-fields (atom {})]
    {:fields viewed-fields
     :sniffer
      (reify OutputFieldsDeclarer
        (declareStream [_ stream direct? fields]
          (swap! viewed-fields (fn [old]
                                 (-> old
                                     (assoc-in [stream "fields"] (into [] fields))
                                     (assoc-in [stream "direct"] direct?)))))

        (declareStream [this stream fields]
          (.declareStream this stream false fields))

        (declare [this direct? fields]
          (.declareStream this "default" direct? fields))

        (declare [this fields]
          (.declare this false fields)))}))



(defn sniff-output-fields
  [sniffer-map component]
  (.declareOutputFields ^IComponent component (:sniffer sniffer-map))
  @(:fields sniffer-map))