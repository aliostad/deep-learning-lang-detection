(defproject org.onyxplatform/onyx-metrics "0.10.0.0"
  :description "Instrument Onyx workflows"
  :url "https://github.com/onyx-platform/onyx-metrics"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :repositories {"snapshots" {:url "https://clojars.org/repo"
                              :username :env
                              :password :env
                              :sign-releases false}
                 "releases" {:url "https://clojars.org/repo"
                             :username :env
                             :password :env
                             :sign-releases false}}
  :dependencies [[org.onyxplatform/onyx "0.10.0"]
                 ^{:voom {:repo "git@github.com:onyx-platform/onyx.git" :branch "master"}}
                 [org.clojure/clojure "1.8.0"]
                 [metrics-clojure "2.8.0"]]
  :java-opts ^:replace ["-server" "-Xmx3g"]
  :global-vars  {*warn-on-reflection* true
                 *assert* false
                 *unchecked-math* :warn-on-boxed}
  :profiles {:dev {:jvm-opts ["-Xmx2500M"
                              "-XX:+UnlockCommercialFeatures"
                              "-XX:+FlightRecorder"
                              "-Dcom.sun.management.jmxremote.port=5555"
                              "-Dcom.sun.management.jmxremote.authenticate=false"
                              "-Dcom.sun.management.jmxremote.ssl=false"
                              "-XX:StartFlightRecording=duration=1080s,filename=recording.jfr"]
                   :dependencies [[riemann-clojure-client "0.4.1"]
                                  [stylefruits/gniazdo "0.4.0"]
                                  [org.clojure/java.jmx "0.3.3"]
                                  [clj-http "2.1.0"]
                                  [cheshire "5.5.0"]
                                  [cognician/dogstatsd-clj "0.1.1"]]
                   :plugins [[lein-set-version "0.4.1"]
                             [lein-update-dependency "0.1.2"]
                             [lein-pprint "1.1.1"]]}})
