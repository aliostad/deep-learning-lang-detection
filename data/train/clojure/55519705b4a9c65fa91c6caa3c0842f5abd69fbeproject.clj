(defproject immutant-hystrix-event-stream "0.1.0-SNAPSHOT"
  :description "Hystrix Metrics Event Stream ring handler for immutant"
  :url "http://github.com/eunmin/immutant-hystrix-event-stream"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [org.clojure/core.async "0.2.385"]
                 [org.immutant/web "2.1.5"]
                 [com.netflix.hystrix/hystrix-metrics-event-stream "1.5.3"]])
